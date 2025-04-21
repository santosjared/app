import 'dart:io';

import 'package:app/config/http.dart';
import 'package:app/models/complaints_model.dart';

class ComplaintsService {
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
}
