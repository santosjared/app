import 'package:app/models/complaints_model.dart';

class ComplaintsResponse {
  final List<ComplaintsModel> result;
  final int total;

  ComplaintsResponse({required this.result, required this.total});

  factory ComplaintsResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintsResponse(
      result:
          (json['result'] as List)
              .map((item) => ComplaintsModel.fromJson(item))
              .toList(),
      total: json['total'] ?? 0,
    );
  }
}
