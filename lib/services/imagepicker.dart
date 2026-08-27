import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<XFile?> pickImage() async {
  try {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    return image;
  } catch (e) {
    debugPrint('Error picking image: $e');
    return null;
  }
}
