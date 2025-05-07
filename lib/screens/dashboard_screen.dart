import 'dart:convert';
import 'package:app/services/auth_service.dart';
import 'package:app/storage/user_storage.dart';
import 'package:app/utils/getinials.dart';
import 'package:app/widgets/menu_wraper.dart';
import 'package:app/widgets/type_complaints.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  _DasboardScreen createState() => _DasboardScreen();
}

class _DasboardScreen extends State<DashboardScreen> {
  final AuthService auth = AuthService();
  String _name = '';
  String _lastName = '';
  String _email = '';
  String _userId = '';
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    final String? userData = await UserStorage.getUser();
    if (userData != null) {
      final user = jsonDecode(userData) as Map<String, dynamic>;
      setState(() {
        _name = user['name'] ?? '';
        _lastName = user['lastName'] ?? '';
        _email = user['email'] ?? '';
        _userId = user['userId'] ?? '';
        _isloading = false;
      });
    } else {
      print(
        'elselllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll',
      );
      setState(() {
        _isloading = false;
      });
      // Navigator.pushReplacementNamed(context, '/splash');
    }
  }

  void _logout() async {
    await auth.logout();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
  }

  get onChanged => null;

  Widget _content = TypeComplaints();

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
          appBar: AppBar(
            title: const Text('Inicio'),
            backgroundColor: Color.fromARGB(255, 0, 142, 150),
            foregroundColor: Colors.white,
            actions: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Emergecia'),
                ),
              ),
            ],
          ),
          body: _content,
          drawer: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
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
                          Inials.getInials(_name, _lastName),
                          style: TextStyle(color: Colors.indigoAccent),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$_name $_lastName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle, color: Colors.teal),
                  title: Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
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
                        userId: _userId,
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
                        userId: _userId,
                        status: 'accepted',
                        title: 'Denuncias aceptadas',
                      );
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.query_builder,
                    color: Colors.orange,
                  ),
                  title: Text('Denuncias en espera'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _content = MenuWraper(
                        key: UniqueKey(),
                        userId: _userId,
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
                        userId: _userId,
                        status: 'refused',
                        title: 'Denuncias rechazadas',
                      );
                    });
                  },
                ),

                Divider(),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blueGrey),
                  title: Text('Configuraciones'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Boton de emergencia '),
                    Switch(
                      value: false,
                      onChanged: onChanged,
                      activeColor:
                          Colors.lightBlue, // Color del "thumb" (botón)
                      // activeTrackColor: Palette.lightPrimary, // Color del fondo cuando está activo
                      inactiveThumbColor: const Color.fromARGB(
                        255,
                        52,
                        210,
                        28,
                      ), // Color del botón cuando está apagado
                      inactiveTrackColor: const Color.fromARGB(255, 1, 102, 15),
                    ),
                  ],
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
