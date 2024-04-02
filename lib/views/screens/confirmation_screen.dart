import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tikstore/controllers/uploadvideo_controller.dart';
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
  bool _isUploading = false; // Variable to track upload status

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  // Method to pick an image from the gallery
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
            const SizedBox(
              height: 30,
            ),
            // Display video player
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Text input fields for song name and caption
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _productController,
                      keyboardType: TextInputType.text,
                      labelText: 'Product Name',
                      icon: Icons.title,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      labelText: 'Price',
                      icon: Icons.currency_rupee,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _songController,
                      labelText: 'Song',
                      icon: Icons.music_note,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Description',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Button to pick an image from the gallery
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text(
                      'Pick Thumbnail',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Display selected image if available
                  if (_imageFile != null) ...[
                    Image.file(_imageFile!),
                    const SizedBox(height: 10),
                  ],
                  // Button to upload video
                  ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : () async {
                            setState(() {
                              _isUploading = true; // Start upload process
                            });
                            // Perform video upload
                            await uploadVideoController.uploadVideo(
                              price: double.parse(_priceController.text),
                              productName: _productController.text,
                              songName: _songController.text,
                              caption: _captionController.text,
                              videoPath: widget.videoPath,
                              thumbnailFile: _imageFile,
                            );
                            setState(() {
                              _isUploading = false; // End upload process
                            });
                          },
                    child: _isUploading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
