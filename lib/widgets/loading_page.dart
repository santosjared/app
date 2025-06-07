import 'dart:io';

import 'package:app/config/http.dart';
import 'package:app/models/complaints_client_model.dart';
import 'package:app/models/previa_model.dart';
import 'package:app/utils/forma_data_complaints.dart';
import 'package:app/widgets/sample_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  final ComplaintsClientModel complaints;
  const LoadingPage({super.key, required this.complaints});

  @override
  State<LoadingPage> createState() => _LoadingPage();
}

class _LoadingPage extends State<LoadingPage> {
  bool _brokenUpload = false;
  double _progress = 0;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      sendComplaints();
    }
  }

  void _nextPage(PreviaModel previa) {
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/previa',
        arguments: {
          'complaint': previa,
          'title': 'Denuncias enviadas',
          'path': '/',
        },
      );
    }
  }

  Future<void> sendComplaints() async {
    try {
      final formData = await widget.complaints.toFormData();
      final response = await dio.post(
        '/complaints-client',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: (count, total) {
          setState(() {
            _progress = count / total;
          });
        },
      );
      if (response.statusCode == HttpStatus.created) {
        PreviaModel previa = PreviaModel.fromJson(response.data);
        _nextPage(previa);
      }
    } catch (e) {
      if (e is DioException) {
        print('⚠️ DioException:');
        print('Status: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
        print('Request: ${e.requestOptions}');
      } else {
        print('❌ Otro error: $e');
      }
      setState(() {
        _brokenUpload = true;
      });
    }
  }

  @override
  Widget build(BuildContext contex) {
    return Scaffold(
      body:
          _brokenUpload
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card.filled(
                        color: const Color.fromARGB(
                          255,
                          254,
                          175,
                          175,
                        ).withOpacity(0.6),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: SampleCard(
                            cardName:
                                'Error al enviar denucia o comuníquese a la línea 110 radio patrulla',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/complaints',
                          );
                        },
                        child: Text('Vover atras'),
                      ),
                    ],
                  ),
                ),
              )
              : Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.blueGrey,
                        color: Colors.blue,
                        minHeight: 15,
                      ),
                      SizedBox(height: 10),
                      Text('Enviando la denuncia espere un momento'),
                    ],
                  ),
                ),
              ),
    );
  }
}
