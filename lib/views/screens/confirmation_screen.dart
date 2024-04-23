import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikstore/controllers/uploadvideo_controller.dart';
import 'package:tikstore/views/screens/home_screen.dart';
import 'package:tikstore/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _productController = TextEditingController();

  File? _imageFile;
  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.play();
        controller.setVolume(1.0);
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _songController.dispose();
    _captionController.dispose();
    _priceController.dispose();
    _productController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: controller.value.isInitialized
                  ? VideoPlayer(controller)
                  : Container(),
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextInputField(
                    controller: _productController,
                    keyboardType: TextInputType.text,
                    labelText: 'Product Name',
                    icon: Icons.title),
                const SizedBox(height: 10),
                TextInputField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    labelText: 'Price',
                    icon: Icons.currency_rupee),
                const SizedBox(height: 10),
                TextInputField(
                    controller: _songController,
                    labelText: 'Song',
                    icon: Icons.music_note),
                const SizedBox(height: 10),
                TextInputField(
                    controller: _captionController,
                    labelText: 'Description',
                    icon: Icons.closed_caption),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Thumbnail',
                        style: TextStyle(fontSize: 20, color: Colors.white))),
                if (_imageFile != null) ...[
                  Image.file(_imageFile!),
                  const SizedBox(height: 10),
                ],
                ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () async {
                          if (!_isUploading) {
                            setState(() {
                              _isUploading = true; // Start upload process
                            });
                            try {
                              await uploadVideoController.uploadVideo(
                                songName: _songController.text,
                                caption: _captionController.text,
                                videoPath: widget.videoPath,
                                price: _priceController.text.isEmpty
                                    ? null
                                    : double.tryParse(_priceController.text),
                                productName: _productController.text,
                                thumbnailFile: _imageFile,
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen())); // Navigate after successful upload
                            } catch (e) {
                              Get.snackbar(
                                  'Error', 'Failed to upload video: $e');
                            } finally {
                              setState(() {
                                _isUploading = false; // End upload process
                              });
                            }
                          }
                        },
                  child: _isUploading
                      ? const CircularProgressIndicator()
                      : const Text('Upload',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
