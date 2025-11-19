import 'package:flutter/material.dart';
import 'package:app/models/previa_model.dart';
import 'package:app/services/complaints_service.dart';
import 'package:intl/intl.dart';

class MenuWraper extends StatefulWidget {
  final String? status;
  final String userId;
  final String title;

  const MenuWraper({
    super.key,
    this.status,
    required this.userId,
    required this.title,
  });

  @override
  State<MenuWraper> createState() => _MenuWraperState();
}

class _MenuWraperState extends State<MenuWraper> {
  final ComplaintsService complaintsService = ComplaintsService();
  bool _isLoading = true;
  List<PreviaModel> complaints = [];

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    final List<PreviaModel> fetchData = await complaintsService
        .getComplaintsClient(widget.userId, widget.status);
    if (mounted) {
      setState(() {
        complaints = fetchData;
        _isLoading = false;
      });
    }
  }

  Widget _statusChip(String status) {
    late Color color;
    late String title;
    late String description;

    switch (status) {
      case 'acepted':
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (complaints.isEmpty) {
      return const Center(
        child: Text(
          'No hay denuncias disponibles',
          style: TextStyle(color: Colors.blueGrey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/previa',
                arguments: {
                  'complaint': complaint,
                  'title': widget.title,
                  'path': '/',
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (complaint.otherComplaints?.isNotEmpty ?? false)
                      ? complaint.otherComplaints!
                      : (complaint.complaints?.name ?? 'Sin nombre'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha de envío: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        DateFormat(
                          'dd/MM/yyyy – HH:mm',
                        ).format(DateTime.parse(complaint.createdAt)),
                        style: const TextStyle(color: Color(0xFF7f8c8d)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _statusChip(complaint.status),
                const SizedBox(height: 5),
                const Divider(height: 8, color: Colors.blueGrey),
              ],
            ),
          ),
        );
      },
    );
  }
}
