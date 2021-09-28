import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_app_task/Model/UserModel.dart';

// Repo allows all blocks to extract functions needed

// performs user interactions
class UserRepository {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  UserRepository({required this.firebaseAuth});

  // Sign In user
  Future<User?> signIn(String email, String password) async {
    try {
      var auth = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return auth.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> Updateinfo(String? email, String? password, String firstName,
      String lastName, String phone) async {
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    try {
      if (email != null) user!.updateEmail(email);
      if (password != null) user!.updatePassword(password);
      postDetailsToFirestore(firstName, lastName, phone);
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  // Sign up user function
  Future<User?> signUp(String email, String password, String firstName,
      String lastName, String phone) async {
    try {
      var auth = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      postDetailsToFirestore(firstName, lastName, phone);
      return auth.user;
    } catch (e) {
      print(e.toString());
    }
  }

  postDetailsToFirestore(
      String firstName, String lastName, String phone) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstName;
    userModel.secondName = lastName;
    userModel.phone = int.parse(phone);

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");
  }

// sign out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // check signed in user
  Future<bool> isSignedIn() async {
    var currentUser = await firebaseAuth.currentUser;
    return currentUser != null;
  }

  //get current user
  Future<User?> getCurrentUser() async {
    return await firebaseAuth.currentUser;
  }
}
