import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadCurrentUserInfo();
  }

  void loadCurrentUserInfo() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic>? userData = userDoc.data();

    setState(() {
      _usernameController.text = userData?['name'] ?? '';
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> updateProfile() async {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    String profileUrl = '';
    if (_image != null) {
      var storageReference = FirebaseStorage.instance
          .ref()
          .child('profilePictures/${FirebaseAuth.instance.currentUser!.uid}');
      await storageReference.putFile(_image!);
      profileUrl = await storageReference.getDownloadURL();
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': _usernameController.text,
      'profilePhoto': profileUrl.isEmpty
          ? (FirebaseAuth.instance.currentUser!.photoURL ?? '')
          : profileUrl,
    }).then((value) {
      Get.back();
      Get.back();
      Get.snackbar(
        'Profile Updated',
        'Your profile has been successfully updated!',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }).catchError((error) {
      Get.back();
      Get.snackbar(
        'Update Failed',
        'Failed to update your profile. Please try again.',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => pickImage(),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _image != null
                    ? FileImage(_image!) as ImageProvider
                    : FirebaseAuth.instance.currentUser!.photoURL != null
                        ? NetworkImage(
                                FirebaseAuth.instance.currentUser!.photoURL!)
                            as ImageProvider
                        : null,
                child: _image == null &&
                        FirebaseAuth.instance.currentUser!.photoURL == null
                    ? Icon(Icons.add_photo_alternate, size: 60)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => updateProfile(),
              child: Text('Update Profile'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
