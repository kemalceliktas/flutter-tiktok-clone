import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiktok_clone_app/constants.dart';
import 'package:tiktok_clone_app/models/comment.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);

  List<Comment> get comments => _comments.value;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(
      firebase
          .collection("videos")
          .doc(_postId)
          .collection("comments")
          .snapshots()
          .map(
        (QuerySnapshot query) {
          List<Comment> retValue = [];
          for (var element in query.docs) {
            retValue.add(Comment.fromSnap(element));
          }
          return retValue;
        },
      ),
    );
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firebase
            .collection("users")
            .doc(authController.user.uid)
            .get();
        var allDocs = await firebase
            .collection("videos")
            .doc(_postId)
            .collection("comments")
            .get();

        int len = allDocs.docs.length;

        Comment comment = Comment(
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          id: "Comment $len",
          likes: [],
          profilePhoto: (userDoc.data()! as dynamic)["profilePhoto"],
          uid: authController.user.uid,
          username: (userDoc.data()! as dynamic)["name"],
        );
        await firebase
            .collection("videos")
            .doc(_postId)
            .collection("comments")
            .doc("Comment $len")
            .set(comment.toJson());
        DocumentSnapshot doc =
            await firebase.collection("videos").doc(_postId).get();

        firebase.collection("videos").doc(_postId).update({
          "commentCount": (doc.data()! as dynamic)["commentCount"] + 1,
        });
      }
    } catch (e) {
      Get.snackbar("Error comment", e.toString());
    }
  }


  likeComment(String id)async{
    var uid = authController.user.uid;
    DocumentSnapshot doc = await firebase.collection("videos").doc(_postId).collection("comments").doc(id).get();
    if ((doc.data()! as dynamic)["likes"].contains(uid)) {
     await firebase.collection("videos").doc(_postId).collection("comments").doc(id).update({
        "likes":FieldValue.arrayRemove([uid]),
      });
    }else{
     await firebase.collection("videos").doc(_postId).collection("comments").doc(id).update({
        "likes":FieldValue.arrayUnion([uid]),
      });
    }
  }
}
