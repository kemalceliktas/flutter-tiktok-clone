import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone_app/controllers/auth_controller.dart';
import 'package:tiktok_clone_app/views/screens/add_video_screen.dart';
import 'package:tiktok_clone_app/views/screens/profile_screen.dart';
import 'package:tiktok_clone_app/views/screens/search_screen.dart';
import 'package:tiktok_clone_app/views/screens/video_screen.dart';

// Colors

const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;


//FİREBASE METHODS


var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage= FirebaseStorage.instance;
var firebase= FirebaseFirestore.instance;

//SCREENS

List pages = [
  VideoScreen(),
 SearchScreen(),
  AddVideoScreen(),
  Text("Messages Screen"),
  ProfileScreen(uid: authController.user.uid),
];

//Auth controller

var authController = AuthController.instance;


pickImage(ImageSource source)async{
  final ImagePicker _imagePicker =ImagePicker();

  XFile? _file=await _imagePicker.pickImage(source: source);

 if (_file !=null) {
    return await _file.readAsBytes();
 }


 print("No image selected");



}