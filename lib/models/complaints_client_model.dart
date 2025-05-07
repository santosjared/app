import 'dart:io';

class LocationUser {
  final double latitude;
  final double longitude;

  LocationUser({required this.latitude, required this.longitude});

  factory LocationUser.fromJson(Map<String, dynamic> json) {
    return LocationUser(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class ComplaintsClientModel {
  final String userId;
  final String? complaints;
  final String? aggressor;
  final String? victim;
  final String? place;
  final String? description;
  final LocationUser? location;
  final List<File>? images;
  final File? video;
  final String? otherComaplints;
  final String? otherAggressor;
  final String? otherVictim;

  ComplaintsClientModel({
    required this.userId,
    this.complaints,
    this.aggressor,
    this.victim,
    this.place,
    this.description,
    this.location,
    this.images,
    this.video,
    this.otherComaplints,
    this.otherAggressor,
    this.otherVictim,
  });
}
