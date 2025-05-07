class Aggressor {
  final String name;

  Aggressor({required this.name});

  factory Aggressor.fromJson(Map<String, dynamic> json) {
    return Aggressor(name: json['name']);
  }
}

class Victim {
  final String name;

  Victim({required this.name});

  factory Victim.fromJson(Map<String, dynamic> json) {
    return Victim(name: json['name']);
  }
}

class ComplaintType {
  final String name;

  ComplaintType({required this.name});

  factory ComplaintType.fromJson(Map<String, dynamic> json) {
    return ComplaintType(name: json['name']);
  }
}

class PreviaModel {
  final ComplaintType? complaints;
  final String? otherComplaints;
  final Aggressor? aggressor;
  final Victim? victim;
  final String? otherAggresor;
  final String? otherVictim;
  final String? description;
  final String? place;
  final List<String> images;
  final String? video;
  final double? latitude;
  final double? longitude;
  final String status;
  final String createdAt;

  PreviaModel({
    this.complaints,
    this.otherComplaints,
    this.aggressor,
    this.victim,
    this.otherAggresor,
    this.otherVictim,
    this.description,
    this.place,
    required this.images,
    this.video,
    this.latitude,
    this.longitude,
    required this.status,
    required this.createdAt,
  });

  factory PreviaModel.fromJson(Map<String, dynamic> json) {
    return PreviaModel(
      complaints:
          json['complaints'] != null
              ? ComplaintType.fromJson(json['complaints'])
              : null,
      otherComplaints: json['otherComplaints'] ?? '',
      aggressor:
          json['aggressor'] != null
              ? Aggressor.fromJson(json['aggressor'])
              : null,
      victim: json['victim'] != null ? Victim.fromJson(json['victim']) : null,
      otherAggresor: json['otherAggresor'],
      otherVictim: json['otherVictim'],
      description: json['description'],
      place: json['place'],
      images: List<String>.from(json['images'] ?? []),
      video: json['video'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
