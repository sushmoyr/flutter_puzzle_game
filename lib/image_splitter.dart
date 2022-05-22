import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;
import 'package:image_picker/image_picker.dart';

import 'tuple.dart';

class ImageSplitter {
  List<Uint8List> splitImage(Map<String, dynamic> mapData) {
    List<int> input = mapData['input'];
    int size = mapData['size'];
    // convert image to image from image package
    image_lib.Image image = image_lib.decodeImage(input)!;

    int x = 0, y = 0;
    int width = (image.width / size).round();
    int height = (image.height / size).round();

    // split image to parts
    List<image_lib.Image> parts = [];
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        parts.add(image_lib.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    // convert image from image package to Image Widget to display
    List<Uint8List> output = [];
    for (var img in parts) {
      output.add(Uint8List.fromList(image_lib.encodeJpg(img)));
    }

    return output;
  }

  Future<Pair<Image, Uint8List>?> getImage(
      {required ImagePicker picker}) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final image = Image.memory(bytes);

      return Pair(image, bytes);
    }
    return null;
  }
}
