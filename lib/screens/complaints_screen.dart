import 'dart:convert';
import 'package:app/models/complaints_model.dart';
import 'package:app/models/kin_model.dart';
import 'package:app/services/camera_service.dart';
import 'package:app/services/complaints_service.dart';
import 'package:app/services/gallery_service.dart';
import 'package:app/services/kin_service.dart';
import 'package:app/services/location_service.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/render_players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class ComplaintsScreen extends StatefulWidget {
  final ComplaintsModel? complaint;
  const ComplaintsScreen({super.key, this.complaint});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final GalleryService galleryService = GalleryService();
  final CameraService camareService = CameraService();
  final LocationService locationService = LocationService();
  final ComplaintsService complaintsService = ComplaintsService();
  final KinService kinService = KinService();

  TextEditingController complaintsController = TextEditingController();

  ComplaintsModel? selectedComplaint;
  String? selectedAggressor;
  String? selectedVictim;

  List<ComplaintsModel> typeComplaints = [];
  List<KinModel> Kins = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    final List<KinModel> fetchKins = await kinService.getKin();
    List<ComplaintsModel> fetchComplaints = [];
    if (widget.complaint == null) {
      fetchComplaints = await complaintsService.getComplaints();
    }
    setState(() {
      if (widget.complaint != null) {
        complaintsController = TextEditingController(
          text: widget.complaint?.name,
        );
      }
      typeComplaints = fetchComplaints;
      Kins = fetchKins;
    });
  }

  final List<Map<String, String>> cardsdView = [];

  void _showMediaOptions(BuildContext context, String tipo) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text('Foto desde $tipo'),
              enabled:
                  cardsdView.where((item) => item['tipo'] == 'image').length > 3
                      ? false
                      : true,
              onTap: () async {
                Navigator.pop(context);
                if (tipo == 'Galería') {
                  final image = await galleryService.imageFromGallery();
                  if (image != null) {
                    if (image.length > 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Solo se permite como maximo 3 fotos'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else {
                      setState(() {
                        for (var imag in image) {
                          cardsdView.add({'tipo': 'image', 'path': imag.path});
                        }
                      });
                    }
                  }
                } else {
                  final imag = await camareService.imageFromCamera();
                  if (imag != null) {
                    setState(() {
                      cardsdView.add({'tipo': 'image', 'path': imag.path});
                    });
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text('Video desde $tipo'),
              enabled:
                  cardsdView.where((item) => item['tipo'] == 'video').length > 1
                      ? false
                      : true,
              onTap: () async {
                Navigator.pop(context);
                if (tipo == 'Galería') {
                  final video = await galleryService.videoFromGallery();
                  if (video != null) {
                    setState(() {
                      cardsdView.add({'tipo': 'video', 'path': video.path});
                    });
                  }
                } else {
                  final cameVideo = await camareService.videoFromCamera();
                  if (cameVideo != null) {
                    setState(() {
                      cardsdView.add({'tipo': 'video', 'path': cameVideo.path});
                    });
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  _osmMap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Stack(
            children: [
              OSMFlutter(
                controller: mapController,
                mapIsLoading: Center(child: CircularProgressIndicator()),
                osmOption: OSMOption(
                  userTrackingOption: UserTrackingOption(
                    enableTracking: true,
                    unFollowUser: false,
                  ),
                  zoomOption: ZoomOption(
                    initZoom: 16,
                    minZoomLevel: 3,
                    maxZoomLevel: 19,
                    stepZoom: 1.0,
                  ),
                  userLocationMarker: UserLocationMaker(
                    personMarker: MarkerIcon(
                      icon: Icon(
                        Icons.location_history_rounded,
                        color: Colors.blueAccent,
                        size: 62,
                      ),
                    ),
                    directionArrowMarker: MarkerIcon(
                      iconWidget: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.navigation, // ícono de flecha estilo brújula
                            color: Colors.blueAccent,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),

                  roadConfiguration: RoadOption(roadColor: Colors.yellowAccent),
                ),
              ),

              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.my_location, color: Colors.blue),
                        title: Text('Ubicación actual'),
                        onTap: () async {
                          Navigator.pop(context);
                          try {
                            final location = await mapController.myLocation();
                            print(location);
                            final locationMap = {
                              'lat': location.latitude,
                              'lon': location.longitude,
                            };
                            setState(() {
                              cardsdView.add({
                                'tipo': 'location',
                                'location': jsonEncode(locationMap),
                              });
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al obtener la ubicación '),
                              ),
                            );
                            print(e);
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.wifi_tethering,
                          color: Colors.green,
                        ),
                        title: Text('Ubicación en tiempo real'),
                        onTap: () async {
                          Navigator.pop(context);
                          try {
                            final location = await mapController.myLocation();
                            final locationMap = {
                              'lat': location.latitude,
                              'lon': location.longitude,
                            };
                            setState(() {
                              cardsdView.add({
                                'tipo': 'location',
                                'location': jsonEncode(locationMap),
                              });
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al obtener la ubicación'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Argumento recibido: ${widget.complaint?.name}');
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Realizar denuncias',
        path: '/',
        loading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.complaint == null
                  ? Autocomplete<ComplaintsModel>(
                    displayStringForOption:
                        (ComplaintsModel option) => option.name,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return typeComplaints.where(
                        (ComplaintsModel option) => option.name
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()),
                      );
                    },
                    fieldViewBuilder: (
                      context,
                      controller,
                      focusNode,
                      onFieldSubmitted,
                    ) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Tipo de denuncia',
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final ComplaintsModel option = options.elementAt(
                                index,
                              );
                              return ListTile(
                                leading: Image.network(
                                  option.image,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image_not_supported);
                                  },
                                ),
                                title: Text(
                                  option.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                subtitle: Text(
                                  '${option.description.substring(0, option.description.length >= 90 ? 90 : option.description.length)}...',
                                ),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    onSelected: (ComplaintsModel selection) {
                      setState(() {
                        selectedComplaint = selection;
                      });
                    },
                  )
                  : TextField(
                    controller: complaintsController,
                    enabled: false,
                    decoration: InputDecoration(
                      label: Text('Tipo de denuncia'),
                    ),
                  ),
              const SizedBox(height: 18),
              if (selectedComplaint?.name == 'Otro')
                Column(
                  children: [
                    TextField(
                      controller: complaintsController,
                      decoration: InputDecoration(
                        label: Text('Especifica otro tipo de denuncia '),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Agresor'),
                      value: selectedAggressor,
                      items:
                          Kins.map((KinModel option) {
                            return DropdownMenuItem<String>(
                              value: option.name,
                              child: Text(option.name),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAggressor = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Víctima'),
                      value: selectedVictim,
                      items:
                          Kins.map((KinModel option) {
                            return DropdownMenuItem<String>(
                              value: option.name,
                              child: Text(option.name),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedVictim = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción(opcional)',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 18),
              TextField(
                controller: placeController,
                decoration: const InputDecoration(
                  labelText: 'Lugar del hecho(opcional)',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
              ),
              const SizedBox(height: 18),
              cardsdView.isEmpty
                  ? Divider()
                  : RenderPlayers(cardsdView: cardsdView),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Adjuntar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              currentIndex: 3,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: (index) {
                if (index == 0) {
                  _showMediaOptions(context, 'Galería');
                } else if (index == 1) {
                  _showMediaOptions(context, 'Cámara');
                } else if (index == 2) {
                  if (cardsdView
                      .where((item) => item['tipo'] == 'location')
                      .isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Solo se puede enviar una ubicacion'),
                      ),
                    );
                  } else {
                    _osmMap(context);
                  }
                } else if (index == 3) {
                  // ignore: avoid_print
                  print("Enviar formulario"); // Implementar lógica de envío
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.image),
                  label: 'Galería',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt),
                  label: 'Cámara',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.place),
                  label: 'Ubicación',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.send),
                  label: 'Enviar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
