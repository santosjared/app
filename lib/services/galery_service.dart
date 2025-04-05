import 'package:image_picker/image_picker.dart';

class GaleryService {
  final ImagePicker picker = ImagePicker();

  Future<List<XFile>?> ImageFromFallery() async {
    final List<XFile>? image = await picker.pickMultiImage();
    return image;
  }

  Future<XFile?> VideoFromGallery() async {
    final XFile? video = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 3),
    );
    return video;
  }
}
