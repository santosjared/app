import 'package:app/config/whatsapp_config.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/services/whatsapp_service.dart';
import 'package:app/utils/getinials.dart';
import 'package:app/widgets/menu_wraper.dart';
import 'package:app/widgets/type_complaints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DasboardScreen();
}

class _DasboardScreen extends State<DashboardScreen> {
  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _openWhatsapp() async {
    bool succsess = await WhatsappService.openWhatsApp(
      WhatsappConfig.phone,
      message: WhatsappConfig.message,
    );
    if (!succsess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tenemos problemas al abrir whatsapp porfavor intente más tarde.',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  String _replace(String email, {int maxLength = 36}) {
    if (email.length <= maxLength) return email;
    final visiblePart = email.substring(0, maxLength - 3);
    return '$visiblePart...';
  }

  Widget _content = TypeComplaints();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Color.fromARGB(255, 0, 142, 150),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: _openWhatsapp,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Emergecia'),
            ),
          ),
        ],
      ),
      body: _content,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 142, 130),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Text(
                      Inials.getInials(user?.name ?? '', user?.lastName ?? ''),
                      style: TextStyle(color: Colors.indigoAccent),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    maxLines: 1,

                    _replace('${user?.name} ${user?.lastName}', maxLength: 30),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    maxLines: 1,
                    _replace(user?.email ?? ''),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.teal),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: user?.email,
                );
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.pink),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _content = TypeComplaints();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.create, color: Colors.blueAccent),
              title: Text('Realizar denucias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/complaints');
              },
            ),
            ListTile(
              leading: const Icon(Icons.send, color: Colors.blue),
              title: Text('Denuncias enviadas'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _content = MenuWraper(
                    key: UniqueKey(),
                    userId: user?.id ?? '',
                    status: null,
                    title: 'Todas las denuncias',
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.playlist_add_check_circle,
                color: Colors.green,
              ),
              title: Text('Denuncias aceptadas'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _content = MenuWraper(
                    key: UniqueKey(),
                    userId: user?.id ?? '',
                    status: 'accepted',
                    title: 'Denuncias aceptadas',
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.query_builder, color: Colors.orange),
              title: Text('Denuncias en espera'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _content = MenuWraper(
                    key: UniqueKey(),
                    userId: user?.id ?? '',
                    status: 'waiting',
                    title: 'Denuncias en espera',
                  );
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.error, color: Colors.red),
              title: Text('Denuncias rechazadas'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _content = MenuWraper(
                    key: UniqueKey(),
                    userId: user?.id ?? '',
                    status: 'refused',
                    title: 'Denuncias rechazadas',
                  );
                });
              },
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
