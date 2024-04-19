import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // Assuming you're using GetX for navigation

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _usernameController = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
    Navigator.of(context).pop(); // Close the dialog after selection
  }

  void showOptionsDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Image Source'),
        children: [
          SimpleDialogOption(
            onPressed: () => pickImage(ImageSource.gallery),
            child: const ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => pickImage(ImageSource.camera),
            child: const ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfile() async {
    try {
      // Assuming you have a method to get the current user ID
      String uid = 'currentUserUid'; // Get this from your user management logic

      // Update the username
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'username': _usernameController.text,
      });

      // Update the profile picture if a new one was picked
      if (_profileImage != null) {
        String fileName =
            'profile_${uid}_${DateTime.now().millisecondsSinceEpoch}';
        FirebaseStorage storage = FirebaseStorage.instance;
        // Upload the new profile picture
        await storage.ref('profilePics/$fileName').putFile(_profileImage!);
        String imageUrl =
            await storage.ref('profilePics/$fileName').getDownloadURL();

        // Update the user's profile image URL in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profilePic': imageUrl,
        });
      }

      // Navigate back to the ProfileScreen after updates are successful
      Get.back(); // Using GetX for navigation
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            if (_profileImage != null)
              Image.file(_profileImage!, height: 200, width: 200),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(_profileImage == null
                  ? 'No Image Selected'
                  : 'Image Selected'),
              trailing: Icon(Icons.edit),
              onTap: showOptionsDialog,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProfile,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
