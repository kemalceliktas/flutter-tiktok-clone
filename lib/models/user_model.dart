import 'package:cloud_firestore/cloud_firestore.dart';


class User {
  final String name;
  final String profilePhoto;
  final String email;
  final String uid;

 const User(
      {required this.name,
      required this.email,
      required this.profilePhoto,
      required this.uid});

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      name: snapshot["name"],
      email: snapshot["email"],
     profilePhoto: snapshot["profilePhoto"],
      uid: snapshot["uid"],
    );
  }
}
