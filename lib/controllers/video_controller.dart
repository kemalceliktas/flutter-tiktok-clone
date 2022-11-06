import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_app/constants.dart';

import '../models/video.dart';

class VideoControler extends GetxController{
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _videoList.bindStream(firebase.collection("videos").snapshots().map((QuerySnapshot query){
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(Video.fromSnap(element),);
      }

      return retVal;

    }));
  }


  likesVideo(String id)async{
    DocumentSnapshot doc =await firebase.collection("videos").doc(id).get();
    var uid  = authController.user.uid;
    if ((doc.data()! as dynamic)["likes"].contains(uid)) {
      await firebase.collection("videos").doc(id).update({
        "likes":FieldValue.arrayRemove([uid])
      });
    }else{
      await firebase.collection("videos").doc(id).update({
        "likes":FieldValue.arrayUnion([uid]),
      });
    }

  }
}