import 'package:app/models/complaints_client_model.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

extension ComplaintsFormData on ComplaintsClientModel {
  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.add(MapEntry('userId', userId));
    if (complaints != null) {
      formData.fields.add(MapEntry('complaints', complaints!));
    }
    if (aggressor != null) {
      formData.fields.add(MapEntry('aggressor', aggressor!));
    }
    if (victim != null) formData.fields.add(MapEntry('victim', victim!));
    if (place != null) formData.fields.add(MapEntry('place', place!));
    if (description != null) {
      formData.fields.add(MapEntry('description', description!));
    }
    if (otherComaplints != null) {
      formData.fields.add(MapEntry('otherComplaints', otherComaplints!));
    }
    if (otherAggressor != null) {
      formData.fields.add(MapEntry('otherAggresor', otherAggressor!));
    }
    if (otherVictim != null) {
      formData.fields.add(MapEntry('otherVictim', otherVictim!));
    }

    if (location != null) {
      formData.fields.add(
        MapEntry('latitude', location!.latitude.toStringAsFixed(8)),
      );
      formData.fields.add(
        MapEntry('longitude', location!.longitude.toStringAsFixed(8)),
      );
    }

    if (images != null && images!.isNotEmpty) {
      for (final image in images!) {
        final fileName = image.path.split('/').last;
        final mimeType = lookupMimeType(image.path);

        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              image.path,
              filename: fileName,
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            ),
          ),
        );
      }
    }

    if (video != null) {
      final fileName = video!.path.split('/').last;
      final mimeType = lookupMimeType(video!.path);
      formData.files.add(
        MapEntry(
          'video',
          await MultipartFile.fromFile(
            video!.path,
            filename: fileName,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        ),
      );
    }

    return formData;
  }
}
