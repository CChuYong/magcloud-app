import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ImagePickerUtil {
  static Future<Image?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      final mimeType = lookupMimeType(image.path);
      final bytes = await image.readAsBytes();

      return Image(mimeType: mimeType ?? '', bytes: bytes);
    } catch (e) {
      return null;
    }
  }
}

class Image {
  final String mimeType;
  final Uint8List bytes;

  Image({required this.mimeType, required this.bytes});
}
