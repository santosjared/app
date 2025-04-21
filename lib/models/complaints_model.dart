class ComplaintsModel {
  final String name;
  final String description;
  final String image;
  final String? id;
  ComplaintsModel({
    required this.name,
    required this.description,
    required this.image,
    this.id,
  });

  factory ComplaintsModel.fromJson(Map<String, dynamic> json) {
    return ComplaintsModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
