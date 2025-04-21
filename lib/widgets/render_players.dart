import 'dart:convert';
import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:video_player/video_player.dart';

class RenderPlayers extends StatefulWidget {
  final List<Map<String, String>> cardsdView;

  const RenderPlayers({super.key, required this.cardsdView});

  @override
  State<RenderPlayers> createState() => _RenderPlayersState();
}

class _RenderPlayersState extends State<RenderPlayers> {
  final List<FlickManager?> _flickManagers = [];
  FlickManager _manager(String path) {
    FlickManager manager = FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.file(File(path)),
    );
    _flickManagers.add(manager);
    return manager;
  }

  @override
  void dispose() {
    for (var manager in _flickManagers) {
      manager?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.cardsdView.length,
      itemBuilder: (context, index) {
        var values = widget.cardsdView[index];

        Widget content;

        if (values['tipo'] == 'video') {
          content = AspectRatio(
            aspectRatio: 16 / 9,
            child: FlickVideoPlayer(flickManager: _manager(values['path']!)),
          );
        } else if (values['tipo'] == 'image') {
          content = GestureDetector(
            onTap: () => _showMediaDialog(context, values),
            child: Image.file(File(values['path']!), fit: BoxFit.cover),
          );
        } else if (values['tipo'] == 'location') {
          final locationString = values['location'];
          if (locationString != null) {
            final locationData = jsonDecode(locationString);
            final double lat = locationData['lat']?.toDouble();
            final double lon = locationData['lon']?.toDouble();

            GeoPoint position = GeoPoint(latitude: lat, longitude: lon);

            final localMapController = MapController.withPosition(
              initPosition: position,
            );

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: content,
            ),
          ),
        );
      },
    );
  }

  void _showMediaDialog(BuildContext context, Map<String, String> media) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: InteractiveViewer(child: Image.file(File(media['path']!))),
        );
      },
    );
  }
}
