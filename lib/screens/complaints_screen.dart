import 'package:app/services/camare_service.dart';
import 'package:app/services/galery_service.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ComplaintsScreenState createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final GaleryService galeryService = GaleryService();
  final CamareService camareService = CamareService();

  String? selectedComplaint;
  String? selectedAggressor;
  String? selectedVictim;

  final List<String> complaintTypes = [
    'Opción 1',
    'Opción 2',
    'Opción 3',
    'Opción 4',
    'Opción 5',
    'Opción 6',
    'Opción 7',
    'Opción 8',
  ];

  final List<String> people = [
    'Yo',
    'Hermano',
    'Tío',
    'Hermana',
    'Padre',
    'Madre',
    'Otro',
  ];

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
              onTap: () async {
                Navigator.pop(context);
                if (tipo == 'Galería') {
                  final image = await galeryService.ImageFromFallery();
                  if (image != null) {
                    print(image);
                  }
                } else {
                  camareService.ImageFromCamera();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text('Video desde $tipo'),
              onTap: () async {
                Navigator.pop(context);
                if (tipo == 'Galería') {
                  final video = await galeryService.VideoFromGallery();
                  if (video != null) {
                    print(video);
                  }
                } else {
                  camareService.VideoFromCamera();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showMediaOptionsUbication(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text('Ubicación en tiempo real '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_searching),
              title: Text('Ubicación actual'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de denuncia',
                ),
                value: selectedComplaint,
                items:
                    complaintTypes.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedComplaint = newValue;
                  });
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Agresor'),
                      value: selectedAggressor,
                      items:
                          people.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
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
                          people.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
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
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
              ),
              const SizedBox(height: 18),
              TextField(
                controller: placeController,
                decoration: const InputDecoration(
                  labelText: 'Lugar del hecho',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
              ),
              const SizedBox(height: 18),
              Divider(),
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
                  _showMediaOptionsUbication(context);
                  // ignore: avoid_print
                  print("Obtener ubicación"); // Implementar lógica de ubicación
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
