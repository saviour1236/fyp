import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tikstore/controllers/auth_controller.dart';
import 'package:tikstore/views/screens/upload_videoscreen.dart';

const pages = [
  Text('Home Screen'),
  Text('Messages Screen'),
  AddVideoScreen(),
  Text('Following Screen'),
  Text('Profile Screen'),
];
//colors
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

//firebase
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

//controllers
var authController = AuthController.instance;
