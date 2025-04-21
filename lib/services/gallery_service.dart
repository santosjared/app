import 'package:image_picker/image_picker.dart';

class GalleryService {
  final ImagePicker picker = ImagePicker();

  Future<List<XFile>?> imageFromGallery() async {
    final List<XFile>? image = await picker.pickMultiImage();
    return image;
  }

  Future<XFile?> videoFromGallery() async {
    final XFile? video = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 3),
    );
    return video;
  }
}
