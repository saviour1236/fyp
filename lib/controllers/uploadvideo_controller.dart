import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tikstore/constants.dart';
import 'package:tikstore/models/video.dart';
import 'package:uuid/uuid.dart';

class UploadVideoController extends GetxController {
  bool _isUploading = false;

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(File(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadImageToStorage(String id, String imagePath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(File(imagePath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> uploadVideo({
    required String songName,
    required String caption,
    required String videoPath,
    double? price,
    String? productName,
    File? thumbnailFile,
  }) async {
    if (_isUploading) return; // Prevent duplicate uploads
    _isUploading = true;
    update(); // Notify listeners about the state change

    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      var videoId = Uuid().v4(); // Generate a unique ID for the video
      String videoUrl =
          await _uploadVideoToStorage("Video $videoId", videoPath);
      String thumbnailUrl = '';

      if (thumbnailFile != null) {
        thumbnailUrl = await _uploadImageToStorage(
            "Thumbnail $videoId", thumbnailFile.path);
      }

      Video video = Video(
        username: (userDoc.data() as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $videoId",
        likes: [],
        price: price,
        productName: productName,
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data() as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnailUrl,
      );

      await FirebaseFirestore.instance
          .collection('videos')
          .doc('Video $videoId')
          .set(video.toJson());

      Get.snackbar('Success', 'Video uploaded successfully!');
    } catch (e) {
      Get.snackbar('Error Uploading Video', e.toString());
      print("Upload failed: $e"); // Log the error for debugging
    } finally {
      _isUploading = false;
      update();
    }
  }

  bool get isUploading => _isUploading;
}
