class KinModel {
  final String name;
  final String? id;
  KinModel({required this.name, this.id});

  factory KinModel.fromJson(Map<String, dynamic> json) {
    return KinModel(name: json['name'] ?? '', id: json['_id'] ?? '');
  }
}
