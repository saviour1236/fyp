import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tikstore/constants.dart';

class AuthController extends GetxController {
  final RxBool _isLoading = RxBool(false);
  RxBool get isLoading => _isLoading;

  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  User? get user => _user.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    // _user.bindStream(firebaseAuth.authStateChanges());
    // ever(_user, _setInitialScreen);
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering the user
  Future<String> registerUser(
      String username, String email, String password, File? image) async {
    String result = 'OK';
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // save out user to our ath and firebase firestore

        _isLoading.value = true;

        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String downloadUrl = await _uploadToStorage(image);

        final data = {
          'name': username,
          'email': email,
          'uid': cred.user!.uid,
          'profilePhoto': downloadUrl,
          'role': 'user',
          'isVerified': false,
        };

        await firestore.collection('users').doc(cred.user!.uid).set(data);
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      result = 'Error Creating Account';
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }

    _isLoading.value = false;

    return result;
  }

  Future<String> loginUser(String email, String password) async {
    String result = 'login ok';
    _isLoading.value = true;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      result = 'Error Logging in';
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
    }
    _isLoading.value = false;
    return result;
  }

  void signOut() async {
    await firebaseAuth.signOut();
  }
}
