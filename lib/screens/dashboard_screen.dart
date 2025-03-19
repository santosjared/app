import 'package:app/widgets/type_complaints.dart';
import 'package:flutter/material.dart';
// Asegúrate de importar el modelo

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  get onChanged => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Color.fromARGB(255, 0, 142, 150),
        foregroundColor: Colors.white,
      ),
      body: TypeComplaints(),
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
                    child: Text('AA'),
                    // backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    //     ? NetworkImage(user.avatarUrl!)
                    //     : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'admin admin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'admin@gmail.com',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text('Perfil'),
            ),
            Divider(),
            ListTile(leading: const Icon(Icons.home), title: Text('Inicio')),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text('Realizar denucias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/complaints');
              },
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: Text('Denuncias aceptadas'),
            ),
            ListTile(
              leading: const Icon(Icons.error),
              title: Text('Denuncias rechazadas'),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text('Historial de denuncias'),
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Configuraciones'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Boton de emergencia '),
                Switch(
                  value: false,
                  onChanged: onChanged,
                  activeColor: Colors.lightBlue, // Color del "thumb" (botón)
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
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                ); // Redirige a Login
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: const Text(
          'Emergencia',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        icon: const Icon(Icons.emergency_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
