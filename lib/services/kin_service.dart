import 'dart:io';

import 'package:app/config/http.dart';
import 'package:app/models/kin_model.dart';

class KinService {
  Future<List<KinModel>> getKin() async {
    try {
      final response = await dio.get('/complaints/kin');
      print(response.data);
      if (response.statusCode == HttpStatus.ok && response.data is List) {
        return (response.data as List).map((jsonItem) {
          return KinModel.fromJson(jsonItem);
        }).toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
