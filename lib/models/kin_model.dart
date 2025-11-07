class KinModel {
  final String id;
  final String name;

  KinModel({required this.name, this.id = ''});

  factory KinModel.fromJson(Map<String, dynamic> json) {
    return KinModel(name: json['name'] ?? '', id: json['_id'] ?? '');
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}
