import 'package:app/config/env_config.dart';
import 'package:app/layouts/layout_with_appbar.dart';
import 'package:app/models/previa_model.dart';
import 'package:dio/dio.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:video_player/video_player.dart';

class PreviaScreen extends StatefulWidget {
  final PreviaModel data;
  final String title;

  const PreviaScreen({super.key, required this.data, required this.title});

  @override
  State<PreviaScreen> createState() => _PreviaScreen();
}

class _PreviaScreen extends State<PreviaScreen> {
  FlickManager? flickManager;
  late final MapController _mapController;

  bool videoError = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
    if (widget.data.latitude != null && widget.data.longitude != null) {
      _mapController = MapController.withPosition(
        initPosition: GeoPoint(
          latitude: widget.data.latitude!,
          longitude: widget.data.longitude!,
        ),
      );
    }
  }

  Future<void> _loadVideo() async {
    if (widget.data.video != null) {
      final url = '${EnvConfig.apiUrl}/videos/${widget.data.video}';
      final dio = Dio();

      try {
        final response = await dio.head(url);

        if (response.statusCode == 200) {
          final controller = VideoPlayerController.networkUrl(Uri.parse(url));
          await controller.initialize();
          setState(() {
            flickManager = FlickManager(videoPlayerController: controller);
          });
        } else {
          setState(() => videoError = true);
        }
      } catch (e) {
        setState(() => videoError = true);
      }
    }
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  Widget _title(String title) => Text(
    title,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      fontStyle: FontStyle.italic,
    ),
  );

  Widget _subTitle(String subtitle) =>
      Text(subtitle, style: const TextStyle(color: Color(0xFF839192)));

  Widget _infoTile(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_title(label), _subTitle(value)],
  );

  Widget _mapRender() {
    return Card(
      child: SizedBox(
        width: double.infinity,
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: OSMFlutter(
            controller: _mapController,
            mapIsLoading: const Center(child: CircularProgressIndicator()),
            osmOption: OSMOption(
              zoomOption: ZoomOption(initZoom: 16),
              userTrackingOption: UserTrackingOption(enableTracking: false),
            ),
            onMapIsReady: (isReady) async {
              if (isReady) {
                await _mapController.addMarker(
                  GeoPoint(
                    latitude: widget.data.latitude!,
                    longitude: widget.data.longitude!,
                  ),
                  markerIcon: MarkerIcon(
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    late Color color;
    late String title;
    late String description;

    switch (status) {
      case 'accepted':
        color = Colors.greenAccent;
        title = 'Denuncia aceptada';
        description =
            'Tu denuncia ha sido aceptada. En breve se contactará contigo la policía o se desplazará una patrulla.';
        break;
      case 'refused':
        color = Colors.redAccent;
        title = 'Denuncia rechazada';
        description =
            'Tu denuncia ha sido rechazada. Evita realizar denuncias falsas, ya que pueden conllevar sanciones legales.';
        break;
      default:
        color = Colors.orangeAccent;
        title = 'Denuncia en espera';
        description =
            'Tu denuncia está siendo evaluada. En caso de emergencia, dirígete a la pantalla principal y pulsa el botón de emergencia.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Estado de la denuncia: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Descripción:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(description, style: const TextStyle(color: Color(0xFF7f8c8d))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutWithAppbar(
      title: widget.title,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTile(
              'Tipo de denuncia',
              widget.data.otherComplaints != ''
                  ? widget.data.otherComplaints ?? ''
                  : widget.data.complaints!.name,
            ),
            const Divider(color: Colors.blueGrey, height: 10),
            const SizedBox(height: 10.0),
            if (widget.data.aggressor != null ||
                widget.data.otherAggresor != '' ||
                widget.data.victim != null ||
                widget.data.otherVictim != '')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.data.aggressor != null &&
                          widget.data.otherAggresor == '')
                        _infoTile('Agresor', widget.data.aggressor!.name),
                      if (widget.data.otherAggresor != '')
                        _infoTile('Agresor', widget.data.otherAggresor!),
                      if (widget.data.victim != null &&
                          widget.data.otherVictim == '')
                        _infoTile('Víctima', widget.data.victim!.name),
                      if (widget.data.otherVictim != '')
                        _infoTile('Víctima', widget.data.otherVictim!),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                ],
              ),

            if (widget.data.description != '')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('Descripción'),
                  _subTitle(widget.data.description!),
                  const Divider(),
                ],
              ),
            if (widget.data.place != '')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('Lugar del hecho'),
                  _subTitle(widget.data.place!),
                  const Divider(),
                ],
              ),
            if (widget.data.images.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.data.images.length,
                itemBuilder: (context, index) {
                  final image = widget.data.images[index];
                  return Card(
                    child: SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () => _showMediaDialog(context, image),
                          child: Image.network(
                            '${EnvConfig.apiUrl}/images/$image',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 210,
                                color: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ).withOpacity(0.8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: Colors.redAccent,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "No se pudo cargar la imagen",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            SizedBox(height: 5),
            if (widget.data.video != null)
              videoError
                  ? Card(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                    child: SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.redAccent,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "No se pudo cargar el video",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  : flickManager != null
                  ? Card(
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FlickVideoPlayer(flickManager: flickManager!),
                      ),
                    ),
                  )
                  : const SizedBox(height: 200),
            SizedBox(height: 5),
            if (widget.data.latitude != null && widget.data.longitude != null)
              _mapRender(),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _statusChip(widget.data.status),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMediaDialog(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: InteractiveViewer(
            child: Image.network(
              '${EnvConfig.apiUrl}/images/$path',
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 210,
                  color: const Color.fromARGB(221, 24, 24, 24),
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
