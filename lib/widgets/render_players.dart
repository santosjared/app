import 'dart:convert';
import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class RenderPlayers extends StatefulWidget {
  final List<Map<String, dynamic>> cardsdView;
  final void Function(int index) removeItem;

  const RenderPlayers({
    super.key,
    required this.cardsdView,
    required this.removeItem,
  });

  @override
  State<RenderPlayers> createState() => _RenderPlayersState();
}

class _RenderPlayersState extends State<RenderPlayers> {
  final Map<int, FlickManager> _flickManagers = {};
  final Map<int, bool> _videoReady = {};
  final Map<int, MapController> _mapControllers = {}; // ✅ Controladores de mapa

  // Inicializa video
  Future<void> _initManager(int index, String path) async {
    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();
    final flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: controller,
    );
    _flickManagers[index] = flickManager;
    _videoReady[index] = true;

    if (mounted) setState(() {});
  }

  // Libera recursos
  @override
  void dispose() {
    for (var manager in _flickManagers.values) {
      manager.dispose();
    }
    for (var controller in _mapControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Elimina un ítem
  void _removeItem(int index) {
    if (_flickManagers.containsKey(index)) {
      _flickManagers[index]?.dispose();
      _flickManagers.remove(index);
      _videoReady.remove(index);
    }
    if (_mapControllers.containsKey(index)) {
      _mapControllers[index]?.dispose();
      _mapControllers.remove(index);
    }
    widget.removeItem(index);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.cardsdView.length,
      itemBuilder: (context, index) {
        final values = widget.cardsdView[index];
        Widget content;

        if (values['tipo'] == 'video') {
          final XFile file = values['data'] as XFile;
          final String path = file.path;

          if (!_flickManagers.containsKey(index)) {
            _initManager(index, path);
            content = const Center(child: CircularProgressIndicator());
          } else if (_videoReady[index] == true) {
            content = FlickVideoPlayer(flickManager: _flickManagers[index]!);
          } else {
            content = const Center(child: CircularProgressIndicator());
          }
        } else if (values['tipo'] == 'image') {
          final XFile file = values['data'] as XFile;
          final String path = file.path;
          content = GestureDetector(
            onTap: () => _showMediaDialog(context, path),
            child: SizedBox.expand(
              child: Image.file(File(path), fit: BoxFit.cover),
            ),
          );
        } else if (values['tipo'] == 'location') {
          final locationString = values['data'];
          if (locationString != null) {
            final locationData = jsonDecode(locationString);
            final double lat = locationData['latitude']?.toDouble();
            final double lon = locationData['longitude']?.toDouble();
            final GeoPoint position = GeoPoint(latitude: lat, longitude: lon);

            if (!_mapControllers.containsKey(index)) {
              _mapControllers[index] = MapController.withPosition(
                initPosition: position,
              );
            }
            final localMapController = _mapControllers[index]!;

            content = OSMFlutter(
              controller: localMapController,
              mapIsLoading: const Center(child: CircularProgressIndicator()),
              osmOption: OSMOption(
                zoomOption: ZoomOption(initZoom: 16),
                userTrackingOption: UserTrackingOption(enableTracking: false),
              ),
              onMapIsReady: (isReady) async {
                if (isReady) {
                  await localMapController.addMarker(
                    position,
                    markerIcon: MarkerIcon(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 48,
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            content = const Center(child: Text('Ubicación no válida'));
          }
        } else {
          content = const SizedBox();
        }

        return Card(
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox.expand(child: content),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _removeItem(index)),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMediaDialog(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: InteractiveViewer(child: Image.file(File(path))),
        );
      },
    );
  }
}
