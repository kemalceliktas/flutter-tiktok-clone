import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone_app/constants.dart';

import 'package:tiktok_clone_app/models/user_model.dart' as model;
import 'package:tiktok_clone_app/views/screens/home_screen.dart';
import 'package:tiktok_clone_app/views/screens/login_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;
  late String? _imageLast;
  String? get imageLastGet => _imageLast;
  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  Future<String?> uploadFile(
    File filePath,
  ) async {
    try {
      Reference ref = firebaseStorage
          .ref()
          .child('profilePics')
          .child(firebaseAuth.currentUser!.uid);

      UploadTask uploadTask = ref.putFile(filePath);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print(e.toString());
    }
  }

  /*  Future<String> downloadUrl(String imageName)async{
    String downloadUrl = await storage.ref("test/$imageName").getDownloadURL();
    return downloadUrl;
  } */

  void imagePick() async {
    final results = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (results == null) {
      return null;
    }

    _pickedImage = Rx<File?>(File(results.path));

    /* uploadFile(path, ).then((value) => print("Done")); */
  }

  /*  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }
 */
  /* // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  } */

  // registering the user
  void registerUser(
      String username, String email, String password, File image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // save out user to our ath and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String? downloadUrl = await uploadFile(image);
        model.User user = model.User(
          name: username,
          email: email,
          uid: cred.user!.uid,
          profilePhoto: downloadUrl!,
        );
        await firebase
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        Get.snackbar(
            "Successfully", "Your profile has been created go to login page..");
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print("Successs for login");
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Loggin gin',
        e.toString(),
      );
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
    
  }
}