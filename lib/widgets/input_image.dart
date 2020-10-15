import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';

class InputImage extends StatefulWidget {
  final Function onSelectImage;

  InputImage(this.onSelectImage);

  @override
  _InputImageState createState() => _InputImageState();
}

class _InputImageState extends State<InputImage> {
  File _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 400,
      maxWidth: 400,
    );

    /* setState(() {
      _storedImage = File(imageFile.path);
    });
    */
    if (imageFile == null) {
      return;
    }

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
    print(fileName);
  }

  void redo() {
    _storedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.camera_alt),
        onPressed: _takePicture,
      ),
    );
  }
}
