import 'dart:convert';
import 'package:app/services/auth_service.dart';
import 'package:app/utils/getinials.dart';
import 'package:app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:app/models/user_data.dart';
import 'package:app/services/user_service.dart';
import 'package:app/storage/user_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService userService = UserService();
  final AuthService auth = AuthService();

  TextEditingController? _nameController;
  TextEditingController? _lastNameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;

  final _formKey = GlobalKey<FormState>();
  UserData? user;
  bool _isEditable = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final String? storedUser = await UserStorage.getUser();
    if (storedUser != null) {
      final Map<String, dynamic> decoded = jsonDecode(storedUser);
      final String email = decoded['email'] ?? '';

      final UserData? fetchedUser = await userService.getUserData(email);
      if (fetchedUser != null) {
        setState(() {
          user = fetchedUser;
          _nameController = TextEditingController(text: fetchedUser.name);
          _lastNameController = TextEditingController(
            text: fetchedUser.lastName,
          );
          _emailController = TextEditingController(text: fetchedUser.email);
          _phoneController = TextEditingController(text: fetchedUser.phone);
        });
      }
    } else {
      Navigator.pushReplacementNamed(context, '/splash');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _lastNameController?.dispose();
    _emailController?.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (user == null) return;

    if (_formKey.currentState!.validate()) {
      final updatedUser = UserData(
        name: _nameController!.text,
        lastName: _lastNameController!.text,
        email: _emailController!.text,
        phone: '+591${_phoneController!.text}',
        id: user!.id,
      );

      final success = await userService.updateUserData(updatedUser);
      if (success) {
        setState(() {
          user = updatedUser;
          _isEditable = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null && !_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Usuario no encontrado'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Text('Volver atras'),
              ),
            ],
          ),
        ),
      );
    }
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 16,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isEditable = !_isEditable;
                            });
                          },
                          icon: Icon(
                            _isEditable ? Icons.check : Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 35,
                      child: Text(Inials.getInials(user!.name, user!.lastName)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${user!.name} ${user!.lastName}',
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    Text(
                      user!.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildInputRow('Nombre', Icons.person, _nameController, (
                          value,
                        ) {
                          String? error = Validator.validate(value, [
                            Validator.isRequired(
                              message: 'El campo Nombres es Requerido.',
                            ),
                            Validator.isString(
                              message:
                                  'El campo Nombres deber ser una cadena de caracteres.',
                            ),
                            Validator.matches(
                              RegExp(r'^[A-Za-z\s]+$'),
                              message:
                                  'El campo Nombres debe contener solo letras y espacio.',
                            ),
                            Validator.length(
                              4,
                              20,
                              message:
                                  'El campo Nombres debe ser como mínimo 4 y como máximo 20 caracteres.',
                            ),
                          ]);
                          return error;
                        }),
                        _buildInputRow(
                          'Apellidos',
                          Icons.person_outline,
                          _lastNameController,
                          (value) {
                            String? error = Validator.validate(value, [
                              Validator.isRequired(
                                message: 'El campo Apellidos es Requerido.',
                              ),
                              Validator.isString(
                                message:
                                    'El campo Apellidos deber ser una cadena de caracteres.',
                              ),
                              Validator.matches(
                                RegExp(r'^[A-Za-z\s]+$'),
                                message:
                                    'El campo Apellidos debe contener solo letras y espacio.',
                              ),
                              Validator.length(
                                4,
                                20,
                                message:
                                    'El campo Apellidos debe ser como mínimo 4 y como máximo 20 caracteres.',
                              ),
                            ]);
                            return error;
                          },
                        ),
                        _buildInputRow(
                          'Correo electrónico',
                          Icons.email,
                          _emailController,
                          (value) {
                            String? error = Validator.validate(value, [
                              Validator.isRequired(
                                message:
                                    'El campo Correo electrónico es Requerido.',
                              ),
                              Validator.isString(
                                message:
                                    'El campo Correo electrónico deber ser una cadena de caracteres.',
                              ),
                              Validator.matches(
                                RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                ),
                                message:
                                    'El campo Correo electrónico es de tipo email.',
                              ),
                              Validator.length(
                                8,
                                64,
                                message:
                                    'El campo Correo electrónico debe ser como mínimo 8 y como máximo 64 caracteres.',
                              ),
                            ]);
                            return error;
                          },
                        ),
                        _buildInputRow(
                          'Teléfono',
                          Icons.phone,
                          _phoneController,
                          (value) {
                            String? error = Validator.validate(value, [
                              Validator.isRequired(
                                message:
                                    'El campo Número de celular es Requerido.',
                              ),
                              Validator.matches(
                                RegExp(r'^\d+$'),
                                message: 'Debe introducir solo números',
                              ),
                              Validator.length(
                                6,
                                16,
                                message:
                                    'El campo Número de celular debe ser como mínimo 6 y como máximo 16 caracteres.',
                              ),
                            ]);
                            return error;
                          },
                        ),
                        if (_isEditable)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              child: const Text('Guardar'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 0.0,
                  right: 16.0,
                  left: 16.0,
                ),
                child: Card(
                  child: InkWell(
                    onTap: () async {
                      await auth.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.logout, color: Colors.red),
                          const SizedBox(width: 8),
                          const Text(
                            'Cerrar sesión',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    IconData icon,
    TextEditingController? controller,
    String? Function(String?) validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
        TextFormField(
          controller: controller,
          enabled: _isEditable,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(),
            errorBorder: UnderlineInputBorder(),
            focusedErrorBorder: UnderlineInputBorder(),
          ),
          validator: validator,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
