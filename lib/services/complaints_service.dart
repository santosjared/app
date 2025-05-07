import 'dart:io';
import 'package:app/config/http.dart';
import 'package:app/models/complaints_client_model.dart';
import 'package:app/models/complaints_model.dart';
import 'package:app/models/previa_model.dart';
import 'package:app/utils/forma_data_complaints.dart';
import 'package:dio/dio.dart';

class ComplaintsService {
  Future<bool> create(ComplaintsClientModel complaints) async {
    try {
      final formData = await complaints.toFormData();
      final response = await dio.post(
        '/complaints',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode == HttpStatus.created) return true;
      return false;
    } catch (e) {
      print('error al crear denuncias $e');
      return false;
    }
  }

  Future<List<ComplaintsModel>> getComplaints() async {
    try {
      final response = await dio.get('/complaints/type-complaints');

      if (response.statusCode == HttpStatus.ok && response.data is List) {
        return (response.data as List).map((jsonItem) {
          return ComplaintsModel.fromJson(jsonItem);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching complaints: $e');
      return [];
    }
  }

  Future<List<PreviaModel>> getComplaintsClient(
    String userId,
    String? status,
  ) async {
    try {
      final response = await dio.get(
        '/complaints-client?userId=$userId&status=${status ?? ''}',
      );
      if (response.statusCode == HttpStatus.ok && response.data is List) {
        return (response.data as List).map((jsonItem) {
          return PreviaModel.fromJson(jsonItem);
        }).toList();
      }
      return [];
    } catch (e) {
      if (e is DioException) {
        print('⚠️ DioException:');
        print('Status: ${e.response?.statusCode}');
        print('Data: ${e.response?.data}');
        print('Request: ${e.requestOptions}');
      } else {
        print('❌ Otro error: $e');
      }
      return [];
    }
  }
}
