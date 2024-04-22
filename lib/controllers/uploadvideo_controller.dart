import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // upload video
  uploadVideo(
      {required String songName,
      required String caption,
      required String videoPath,
      double? price,
      String? productName,
      File? thumbnailFile}) async {
    try {
      _isUploading = true;
      update();

      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('videos').get();
      String len = Uuid().v4();

      String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnailUrl = '';

      if (thumbnailFile != null) {
        thumbnailUrl =
            await _uploadImageToStorage("Thumbnail $len", thumbnailFile.path);
      }

      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        id: "Video $len",
        likes: [],
        price: price,
        productName: productName,
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
        thumbnail: thumbnailUrl,
      );

      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );

      _isUploading = false;
      update();
      Get.back();
    } catch (e) {
      _isUploading = false;
      update();
      Get.snackbar(
        'Error Uploading Video',
        e.toString(),
      );
    }
  }

  bool get isUploading => _isUploading;
}
