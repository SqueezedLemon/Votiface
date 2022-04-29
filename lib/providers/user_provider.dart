import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:votiface/model/user_model.dart';

class UserProvider with ChangeNotifier {
  void addUserData({
    required User currentUser,
    required String firstName,
    required String secondName,
    required String email,
    required String citizenshipNumber,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .set(
      {
        "firstName": firstName,
        "secondName": secondName,
        "email": email,
        "citizenshipNumber": citizenshipNumber,
        "uid": currentUser.uid,
      },
    );
  }

  late UserModel currentData;

  void getUserData() async {
    UserModel userModel;
    var value = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (value.exists) {
      userModel = UserModel(
        firstName: value.get("firstName"),
        secondName: value.get("secondName"),
        email: value.get("email"),
        citizenshipNumber: value.get("citizenshipNumber"),
        uid: value.get("userUid"),
      );
      currentData = userModel;
      notifyListeners();
    }
  }

  UserModel get currentUserData {
    return currentData;
  }
}
