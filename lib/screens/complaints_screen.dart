import 'dart:convert';
import 'dart:io';
import 'package:app/models/complaints_client_model.dart';
import 'package:app/models/complaints_model.dart';
import 'package:app/models/kin_model.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/services/camera_service.dart';
import 'package:app/services/complaints_service.dart';
import 'package:app/services/gallery_service.dart';
import 'package:app/services/kin_service.dart';
import 'package:app/services/location_service.dart';
import 'package:app/utils/validator.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/render_players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ComplaintsScreen extends StatefulWidget {
  final ComplaintsModel? complaint;
  const ComplaintsScreen({super.key, this.complaint});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final GalleryService galleryService = GalleryService();
  final CameraService camareService = CameraService();
  final LocationService locationService = LocationService();
  final ComplaintsService complaintsService = ComplaintsService();
  final KinService kinService = KinService();

  TextEditingController complaintsController = TextEditingController();
  TextEditingController aggressorController = TextEditingController();
  TextEditingController victimContoller = TextEditingController();
  TextEditingController defaultcomplaintsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _loading = true;

  String? _foreceText;

  ComplaintsModel? selectedComplaint;
  KinModel? selectedAggressor;
  KinModel? selectedVictim;

  List<ComplaintsModel> typeComplaints = [];
  List<KinModel> kins = [];

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
    if (mounted) {
      setState(() {
        if (widget.complaint != null) {
          selectedComplaint = widget.complaint;
          defaultcomplaintsController = TextEditingController(
            text: widget.complaint?.name,
          );
        }
        typeComplaints = fetchComplaints;
        kins = fetchKins;
        _loading = false;
      });
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: 3)),
      );
    }
  }

  final List<Map<String, dynamic>> cardsdView = [];

  void _showMediaOptions(BuildContext context, String tipo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.blueAccent),
              title: Text('Foto desde $tipo'),
              enabled:
                  cardsdView.where((item) => item['tipo'] == 'image').length > 2
                      ? false
                      : true,
              onTap: () async {
                Navigator.pop(context);
                if (tipo == 'Galería') {
                  final image = await galleryService.imageFromGallery();
                  if (image != null) {
                    if (image.length > 3 ||
                        image.length +
                                cardsdView
                                    .where((item) => item['tipo'] == 'image')
                                    .length >
                            3) {
                      _showMessage('Solo se permite como maximo 3 fotos');
                    } else {
                      setState(() {
                        for (var imag in image) {
                          cardsdView.add({'tipo': 'image', 'data': imag});
                        }
                      });
                    }
                  }
                } else {
                  final imag = await camareService.imageFromCamera();
                  if (imag != null) {
                    setState(() {
                      cardsdView.add({'tipo': 'image', 'data': imag});
                    });
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.pinkAccent),
              title: Text('Video desde $tipo'),
              enabled:
                  cardsdView.where((item) => item['tipo'] == 'video').isNotEmpty
                      ? false
                      : true,
              onTap: () async {
                Navigator.pop(context);
                if (tipo == 'Galería') {
                  final video = await galleryService.videoFromGallery();
                  if (video != null) {
                    setState(() {
                      cardsdView.add({'tipo': 'video', 'data': video});
                    });
                  }
                } else {
                  final cameVideo = await camareService.videoFromCamera();
                  if (cameVideo != null) {
                    setState(() {
                      cardsdView.add({'tipo': 'video', 'data': cameVideo});
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
                        Icons.location_on,
                        color: Colors.red,
                        size: 96,
                      ),
                    ),
                    directionArrowMarker: MarkerIcon(
                      iconWidget: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 5),
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
                            color: Colors.red,
                            size: 96,
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
                            final locationMap = {
                              'latitude': location.latitude,
                              'longitude': location.longitude,
                            };
                            setState(() {
                              cardsdView.add({
                                'tipo': 'location',
                                'data': jsonEncode(locationMap),
                              });
                            });
                          } catch (e) {
                            _showMessage('Error al obtener la ubicación ');
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

  void _sendComplaints() async {
    if (_formKey.currentState!.validate()) {
      if (selectedComplaint == null && complaintsController.text.isEmpty) {
        setState(() {
          _foreceText =
              'Debe seleccionar un tipo de denuncia u otro tipo de denuncia';
        });
        return;
      }
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        final List<File> images =
            cardsdView
                .where((item) => item['tipo'] == 'image')
                .map<File>((item) => File((item['data'] as XFile).path))
                .toList();
        final File? video =
            cardsdView.firstWhere(
                      (item) => item['tipo'] == 'video',
                      orElse: () => {},
                    )['data'] !=
                    null
                ? File(
                  (cardsdView.firstWhere(
                            (item) => item['tipo'] == 'video',
                            orElse: () => {'data': XFile('')},
                          )['data']
                          as XFile)
                      .path,
                )
                : null;
        final String? locationJson =
            cardsdView.firstWhere(
              (item) => item['tipo'] == 'location',
              orElse: () => {},
            )['data'];

        final LocationUser? location =
            locationJson != null
                ? LocationUser.fromJson(jsonDecode(locationJson))
                : null;

        ComplaintsClientModel complaints = ComplaintsClientModel(
          userId: user.id ?? '',
          aggressor: selectedAggressor?.id,
          complaints: selectedComplaint?.id,
          description: descriptionController.text,
          images: images,
          video: video,
          location: location,
          otherAggressor: aggressorController.text,
          otherComaplints: complaintsController.text,
          otherVictim: victimContoller.text,
          place: placeController.text,
          victim: selectedVictim?.id,
        );

        Navigator.pushReplacementNamed(
          context,
          '/loadingcomplaints',
          arguments: complaints,
        );
      } else {
        Navigator.pushReplacementNamed(context, '/splash');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Realizar denuncias', loading: false),
      body:
          _loading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.complaint == null
                            ? Autocomplete<ComplaintsModel>(
                              displayStringForOption:
                                  (ComplaintsModel option) => option.name,
                              optionsBuilder: (
                                TextEditingValue textEditingValue,
                              ) {
                                return typeComplaints.where(
                                  (ComplaintsModel option) =>
                                      option.name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase(),
                                      ),
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
                                  forceErrorText: _foreceText,
                                  decoration: InputDecoration(
                                    labelText: 'Tipo de denuncia',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    String? error = Validator.validate(value, [
                                      Validator.isRequired(
                                        message: 'Este campo es requerido',
                                      ),
                                    ]);
                                    return error;
                                  },
                                );
                              },
                              optionsViewBuilder: (
                                context,
                                onSelected,
                                options,
                              ) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (context, index) {
                                        final ComplaintsModel option = options
                                            .elementAt(index);
                                        return ListTile(
                                          leading: Image.network(
                                            option.image,
                                            width: 40,
                                            height: 40,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Icon(
                                                Icons.image_not_supported,
                                              );
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
                                  _foreceText = null;
                                  selectedComplaint = selection;
                                });
                              },
                            )
                            : TextField(
                              controller: defaultcomplaintsController,
                              enabled: false,
                              decoration: InputDecoration(
                                label: Text('Tipo de denuncia'),
                              ),
                            ),
                        const SizedBox(height: 18),
                        if (selectedComplaint?.name == 'Otro')
                          Column(
                            children: [
                              TextFormField(
                                controller: complaintsController,
                                decoration: InputDecoration(
                                  label: Text(
                                    'Especifica otro tipo de denuncia ',
                                  ),
                                ),
                                validator: (value) {
                                  String? error = Validator.validate(value, [
                                    Validator.isRequired(
                                      message: 'Este campo es requerido.',
                                    ),
                                    Validator.matches(
                                      RegExp(r'^[A-Za-z\s]+$'),
                                      message:
                                          'Este campo solo debe contener caracteres alfabéticas.',
                                    ),
                                    Validator.length(
                                      4,
                                      20,
                                      message:
                                          'Este campo debe contener mínimo 4 y como máximo 20 caracteres.',
                                    ),
                                  ]);
                                  return error;
                                },
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),

                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<KinModel>(
                                decoration: const InputDecoration(
                                  labelText: 'Agresor (opcional)',
                                ),
                                value: selectedAggressor,
                                items:
                                    kins.map((KinModel option) {
                                      return DropdownMenuItem<KinModel>(
                                        value: option,
                                        child: Text(option.name),
                                      );
                                    }).toList(),
                                onChanged: (KinModel? newValue) {
                                  setState(() {
                                    selectedAggressor = newValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: DropdownButtonFormField<KinModel>(
                                decoration: const InputDecoration(
                                  labelText: 'Víctima (opcional)',
                                ),
                                value: selectedVictim,
                                items:
                                    kins.map((KinModel option) {
                                      return DropdownMenuItem<KinModel>(
                                        value: option,
                                        child: Text(option.name),
                                      );
                                    }).toList(),
                                onChanged: (KinModel? newValue) {
                                  setState(() {
                                    selectedVictim = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        if (selectedAggressor?.name == 'Otro' &&
                            selectedVictim?.name == 'Otro')
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: aggressorController,
                                      decoration: InputDecoration(
                                        label: Text('Especifica otro agresor'),
                                      ),
                                      validator: (value) {
                                        String?
                                        error = Validator.validate(value, [
                                          Validator.isRequired(
                                            message: 'Este campo es requerido.',
                                          ),
                                          Validator.matches(
                                            RegExp(r'^[A-Za-z\s]+$'),
                                            message:
                                                'Este campo solo debe contener caracteres alfabéticas.',
                                          ),
                                          Validator.length(
                                            3,
                                            20,
                                            message:
                                                'Este campo debe contener mínimo 3 y como máximo 20 caracteres.',
                                          ),
                                        ]);
                                        return error;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: TextFormField(
                                      controller: victimContoller,
                                      decoration: InputDecoration(
                                        label: Text('Especifica otro víctima'),
                                      ),
                                      validator: (value) {
                                        String?
                                        error = Validator.validate(value, [
                                          Validator.isRequired(
                                            message: 'Este campo es requerido.',
                                          ),
                                          Validator.matches(
                                            RegExp(r'^[A-Za-z\s]+$'),
                                            message:
                                                'Este campo solo debe contener caracteres alfabéticas.',
                                          ),
                                          Validator.length(
                                            4,
                                            20,
                                            message:
                                                'Este campo debe contener mínimo 4 y como máximo 20 caracteres.',
                                          ),
                                        ]);
                                        return error;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        if (selectedAggressor?.name == 'Otro' &&
                            selectedVictim?.name != 'Otro')
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: aggressorController,
                                      decoration: InputDecoration(
                                        label: Text('Especifica otro agresor'),
                                      ),
                                      validator: (value) {
                                        String?
                                        error = Validator.validate(value, [
                                          Validator.isRequired(
                                            message: 'Este campo es requerido.',
                                          ),
                                          Validator.matches(
                                            RegExp(r'^[A-Za-z\s]+$'),
                                            message:
                                                'Este campo solo debe contener caracteres alfabéticas.',
                                          ),
                                          Validator.length(
                                            3,
                                            20,
                                            message:
                                                'Este campo debe contener mínimo 3 y como máximo 20 caracteres.',
                                          ),
                                        ]);
                                        return error;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(child: SizedBox()),
                                ],
                              ),

                              const SizedBox(height: 18),
                            ],
                          ),
                        if (selectedAggressor?.name != 'Otro' &&
                            selectedVictim?.name == 'Otro')
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: SizedBox()),
                                  SizedBox(width: 18),
                                  Expanded(
                                    child: TextFormField(
                                      controller: victimContoller,
                                      decoration: InputDecoration(
                                        label: Text('Especifica otro víctima'),
                                      ),
                                      validator: (value) {
                                        String?
                                        error = Validator.validate(value, [
                                          Validator.isRequired(
                                            message: 'Este campo es requerido.',
                                          ),
                                          Validator.matches(
                                            RegExp(r'^[A-Za-z\s]+$'),
                                            message:
                                                'Este campo solo debe contener caracteres alfabéticas.',
                                          ),
                                          Validator.length(
                                            3,
                                            20,
                                            message:
                                                'Este campo debe contener mínimo 3 y como máximo 20 caracteres.',
                                          ),
                                        ]);
                                        return error;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 18),
                            ],
                          ),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción (opcional)',
                          ),
                          maxLines: 4,
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: placeController,
                          decoration: InputDecoration(
                            labelText: 'Lugar del hecho (opcional)',
                            prefixIcon: GestureDetector(
                              onTap: () {
                                _osmMap(context);
                              },
                              child: Icon(Icons.place_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        RenderPlayers(
                          cardsdView: cardsdView,
                          removeItem:
                              (index) => setState(() {
                                cardsdView.removeAt(index);
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
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
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap:
                  _loading
                      ? null
                      : (index) {
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
                                content: Text(
                                  'Solo se puede enviar una ubicacion',
                                ),
                              ),
                            );
                          } else {
                            _osmMap(context);
                          }
                        } else if (index == 3) {
                          _sendComplaints();
                        }
                      },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.image, color: Colors.blueAccent),
                  label: 'Galería',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt, color: Colors.pinkAccent),
                  label: 'Cámara',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.place, color: Colors.greenAccent),
                  label: 'Ubicación',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.send, color: Colors.lightGreen),
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
