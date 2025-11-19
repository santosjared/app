import 'dart:async';

import 'package:app/config/env_config.dart';
import 'package:app/layouts/background_layout.dart';
import 'package:app/models/complaints_model.dart';
import 'package:app/models/complaints_response_model.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/services/complaints_service.dart';
import 'package:app/theme/custom_color.dart';
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
  List<ComplaintsModel> typeComplaints = [];
  ComplaintsModel? selectedComplaint;
  final ComplaintsService complaintsService = ComplaintsService();

  Timer? _debounce;

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/login');
  }

  String _replace(String email, {int maxLength = 36}) {
    if (email.length <= maxLength) return email;
    final visiblePart = email.substring(0, maxLength - 3);
    return '$visiblePart...';
  }

  Future<List<ComplaintsModel>> _getDataDB(String value) async {
    final ComplaintsResponse? response = await complaintsService.getComplaints(
      name: value,
      skip: 0,
      limit: 10,
    );
    if (response != null && response.result.isNotEmpty) {
      return response.result;
    }
    return [];
  }

  Widget _content = TypeComplaints();

  _search(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    color: Colors.white,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: controller,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: "Buscar denuncia...",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (_debounce?.isActive ?? false) {
                                  _debounce!.cancel();
                                }

                                // debounce para evitar varias peticiones
                                _debounce = Timer(
                                  const Duration(milliseconds: 500),
                                  () async {
                                    final res = await _getDataDB(value);

                                    setStateDialog(() {
                                      typeComplaints = res;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final res = await _getDataDB(controller.text);

                            setStateDialog(() {
                              typeComplaints = res;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Buscar",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: typeComplaints.length,
                      itemBuilder: (context, index) {
                        final option = typeComplaints[index];

                        return ListTile(
                          leading: Image.network(
                            '${EnvConfig.apiUrl}/images/${option.image}',
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                          ),
                          title: Text(
                            option.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            option.description.length > 90
                                ? "${option.description.substring(0, 90)}..."
                                : option.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            Navigator.pop(context);

                            setState(() {
                              Navigator.pushNamed(
                                context,
                                '/complaints',
                                arguments: option,
                              );
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final colors = CustomColor.of(context);
    return CustomPaint(
      painter: BackgroundLayout(
        backgroundColor: colors.background,
        dotColor: colors.circularBg,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Inicio'),
          backgroundColor: colors.primary.main,
          foregroundColor: colors.primary.contrastText,
          shadowColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _search(context);
              },
            ), ////
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/emergency');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.error.main,
                ),
                child: Text('Emergecia'),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: colors.primary.main,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: colors.primary.dark),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Text(
                        Inials.getInials(
                          user?.name ?? '',
                          user?.lastName ?? '',
                        ),
                        style: TextStyle(color: Colors.indigoAccent),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      maxLines: 1,

                      _replace(
                        '${user?.name} ${user?.lastName}',
                        maxLength: 30,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        color: colors.primary.contrastText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      maxLines: 1,
                      _replace(user?.email ?? ''),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.teal),
                title: Text(
                  'Perfil',
                  style: TextStyle(color: colors.primary.contrastText),
                ),
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
                title: Text(
                  'Inicio',
                  style: TextStyle(color: colors.primary.contrastText),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _content = TypeComplaints();
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.create, color: Colors.blueAccent),
                title: Text(
                  'Realizar denucias',
                  style: TextStyle(color: colors.primary.contrastText),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/complaints');
                },
              ),
              ListTile(
                leading: const Icon(Icons.send, color: Colors.blue),
                title: Text(
                  'Denuncias enviadas',
                  style: TextStyle(color: colors.primary.contrastText),
                ),
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
                title: Text(
                  'Denuncias aceptadas',
                  style: TextStyle(color: colors.primary.contrastText),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _content = MenuWraper(
                      key: UniqueKey(),
                      userId: user?.id ?? '',
                      status: 'acepted',
                      title: 'Denuncias aceptadas',
                    );
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.query_builder, color: Colors.orange),
                title: Text(
                  'Denuncias en espera',
                  style: TextStyle(color: colors.primary.contrastText),
                ),
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
                title: Text(
                  'Denuncias rechazadas',
                  style: TextStyle(color: colors.primary.contrastText),
                ),
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
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(color: colors.primary.contrastText),
                ),
                onTap: () {
                  _logout();
                },
              ),
            ],
          ),
        ),
        body: _content,
      ),
    );
  }
}
