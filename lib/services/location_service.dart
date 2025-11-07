import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Los permisos de ubicación están denegados permanentemente.',
      );
    }

    return true;
  }

  Future<Position> getCurrentLocation() async {
    await _checkPermissions();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );

    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }

  Stream<Position> getLocationStream() async* {
    await _checkPermissions();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    yield* Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  Stream<ServiceStatus> getServiceStatusStream() {
    return Geolocator.getServiceStatusStream();
  }

  Future<bool> isGpsEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
