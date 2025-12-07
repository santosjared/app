import 'dart:io';
import 'package:app/config/http.dart';
import 'package:app/models/kin_model.dart';

class KinService {
  Future<List<KinModel>> getKin() async {
    try {
      final response = await dio.get('/complaints/kin');
      if (response.statusCode == HttpStatus.ok && response.data is List) {
        final List<dynamic> list = response.data;
        final kinList =
            list.map((item) {
              if (item is Map<String, dynamic>) {
                return KinModel.fromJson(item);
              } else {
                return KinModel(name: item.toString());
              }
            }).toList();
        kinList.add(KinModel(id: 'Other', name: 'Otro'));

        return kinList;
      }

      return [];
    } catch (e, stack) {
      print('❌ Error obteniendo kin: $e');
      print(stack);
      return [];
    }
  }
}
