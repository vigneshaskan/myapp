
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImageProcessingScreen extends StatefulWidget {
  const ImageProcessingScreen({Key? key}) : super(key: key);

  @override
  State<ImageProcessingScreen> createState() => _ImageProcessingScreenState();
}

class _ImageProcessingScreenState extends State<ImageProcessingScreen> {
  File? imageFile;
  String? successMessage;
  bool imageCroppedAndResized = false;

  Future _pickImage() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future _resizeImage() async {
    imageCroppedAndResized = true;
    if (imageFile != null) {
      final img.Image image = img.decodeImage(File(imageFile!.path).readAsBytesSync())!;
      final img.Image resizedImage = img.copyResize(image, width: 150, height: 150);
      final resizedFile = File(imageFile!.path.replaceAll(".jpg", "_resized.jpg"));
      await resizedFile.writeAsBytes(Uint8List.fromList(img.encodeJpg(resizedImage)));

      setState(() {
        imageFile = resizedFile;
      });
    }
  }

  Future<void> _saveImage() async {
    Uint8List bytes = await imageFile!.readAsBytes();
    var result = await ImageGallerySaver.saveImage(
      bytes,
      quality: 80,
      name: "my_image.jpg",
    );
    if (result["isSuccess"] == true) {
      print("Image saved successfully.");
      successMessage = 'Image saved successfully!!';

      // Show a Snackbar with the success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage!),
          duration: Duration(seconds: 2), // You can adjust the duration as needed
        ),
      );
    } else {
      print(result["errorMessage"]);
      successMessage = result["errorMessage"];
    }
  }


  Future _cropImage() async {
    imageCroppedAndResized = true;
    if (imageFile != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: imageFile!.path,
          aspectRatioPresets:
          [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],

          uiSettings: [
          AndroidUiSettings(
          toolbarTitle: 'Crop',
          cropGridColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
          IOSUiSettings(title: 'Crop')
    ]);

    if (cropped != null) {
    setState(() {
    imageFile = File(cropped.path);
    });
    }
  }
  }

  void _clearImage() {
    setState(() {
      imageFile = null;
      imageCroppedAndResized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Crop Your Image")),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: imageFile != null
                      ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.file(imageFile!))
                      : const Center(
                    child: Text("Add a picture"),
                  )),
              Expanded(
                child: Center(child: _buildIconButton(icon: Icons.arrow_downward, onpressed: _saveImage)),
              ),
              Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIconButton(icon: Icons.add, onpressed: _pickImage, visible: imageFile == null,),
                        _buildIconButton(icon: Icons.crop, onpressed: _cropImage, visible: imageFile != null,),
                        _buildIconButton(icon: Icons.file_copy, onpressed: _resizeImage, visible: imageFile != null,),
                        if(imageFile != null)
                        _buildIconButton(icon: Icons.clear, onpressed: _clearImage),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget _buildIconButton(
      {required IconData icon, required void Function()? onpressed, bool visible = true}) {
    if (icon == Icons.arrow_downward && !imageCroppedAndResized || !visible) {
      return Container();
    }
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(50)),
        child: IconButton(
          onPressed: onpressed,
          icon: Icon(icon),
          color: Colors.white,
        ));
  }
}
