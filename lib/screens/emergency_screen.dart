import 'package:app/config/http.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:app/services/location_service.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:app/layouts/blank_layout.dart';
import 'package:provider/provider.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final LocationService _locationService = LocationService();
  final TextEditingController phoneController = TextEditingController();

  late final MapController mapController = MapController.withUserPosition(
    trackUserLocation: UserTrackingOption(enableTracking: false),
  );
  StreamSubscription<ServiceStatus>? _gpsStatusSubscription;

  GeoPoint? _currentPosition;
  bool _isLoading = true;
  bool _isLoadingSend = false;
  bool _isReadyMap = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _loadUserLocation();
      _listenGpsStatus();
    }
  }

  /// 🔁 Escucha cambios del GPS (ON/OFF)
  void _listenGpsStatus() {
    _gpsStatusSubscription = _locationService.getServiceStatusStream().listen((
      status,
    ) {
      if (status == ServiceStatus.enabled) {
        debugPrint("✅ GPS habilitado, recargando ubicación...");
        _loadUserLocation();
      } else if (status == ServiceStatus.disabled) {
        debugPrint("⚠️ GPS deshabilitado");
        setState(() {
          _errorMessage = "Los servicios de ubicación están deshabilitados.";
          _isLoading = false;
          _currentPosition = null;
        });
      }
    });
  }

  Future<void> _loadUserLocation() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _locationService.getCurrentLocation();

      if (!mounted) return;

      final userGeoPoint = GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      setState(() {
        _currentPosition = userGeoPoint;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlankLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMapCard(),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Contacto (opcional)',
                  enabled: !_isLoadingSend,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _isLoadingSend
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _enviar,
                      child: Text('Enviar'),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return Card(
      child: SizedBox(
        height: 400,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Builder(
            builder: (context) {
              if (_isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_errorMessage != null || _currentPosition == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_off,
                        color: Colors.grey,
                        size: 60,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Ubicación no disponible",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _loadUserLocation,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reintentar"),
                      ),
                    ],
                  ),
                );
              }

              return OSMFlutter(
                controller: mapController,
                osmOption: OSMOption(
                  zoomOption: ZoomOption(initZoom: 16),
                  userTrackingOption: UserTrackingOption(
                    enableTracking: false,
                    unFollowUser: false,
                  ),
                ),
                onMapIsReady: (ready) async {
                  if (ready && _currentPosition != null) {
                    await mapController.moveTo(_currentPosition!);
                    await mapController.addMarker(
                      _currentPosition!,
                      markerIcon: MarkerIcon(
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                    );
                    if (mounted) {
                      setState(() => _isReadyMap = true);
                    }
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _enviar() async {
    if (!mounted) return;
    setState(() {
      _isLoadingSend = true;
    });
    if (_currentPosition == null) {
      _showMessage("No se pudo obtener la ubicación.");
      return;
    }
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final data = {
      "userId": user != null ? user.id : '',
      "latitude": _currentPosition!.latitude,
      "longitude": _currentPosition!.longitude,
      "contact": phoneController.text.trim(),
    };

    try {
      final response = await dio.post(
        '/complaints-client/emergency',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Datos de emergencia enviados: $data");
        _showMessage("Emergencia enviada correctamente");
      } else {
        debugPrint(
          "⚠️ Error en la respuesta del servidor: ${response.statusCode}",
        );
        _showMessage("Error al enviar la emergencia. Intente nuevamente.");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        _showMessage("Tiempo de conexión agotado. Revisa tu red.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        _showMessage("El servidor no respondió a tiempo.");
      } else if (e.response != null) {
        _showMessage("Error del servidor: ${e.response?.statusCode}");
      } else {
        _showMessage("Error de conexión. Verifica tu red o GPS.");
      }
    } catch (e) {
      _showMessage(
        "No se pudo enviar la ubicación. Comuníquese con 110 Radio Patrullas.",
      );
    }
    setState(() {
      _isLoadingSend = false;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    _gpsStatusSubscription?.cancel();

    if (_isReadyMap) {
      try {
        mapController.dispose();
      } catch (e) {
        debugPrint("⚠️ No se pudo cerrar el mapa: $e");
      }
    }

    super.dispose();
  }
}
