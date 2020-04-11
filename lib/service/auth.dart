import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/model/auth-mode.dart';
import 'package:find/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  String uid;
  AuthService({this.uid});
  Future<Map<String, dynamic>> signIn(
      email, password, mode, firstName, lastName, phone) async {
    AuthResult result;
    bool hassError = true;
    String message = "something went wrong!";
    try {
      if (mode == AuthMode.Login) {
        hassError = false;
        result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        FirebaseUser user = result.user;
        _userFromFirebase(user);
      } else {
        hassError = false;
        result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseUser user = result.user;
        updateUserData(user.uid, user.email, firstName, lastName, phone);
        _userFromFirebase(user);
      }
    } catch (e) {
      hassError = true;
      print(e.toString());
      dynamic error = e.toString();
      if (error.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
        message = "This Email is already exists!";
      } else if (error.contains('ERROR_USER_NOT_FOUND')) {
        message = "The E-mail is invalid!";
      } else if (error.contains('ERROR_WRONG_PASSWORD')) {
        message = "Wrong Password!";
      } else if (error.contains('ERROR_NETWORK_REQUEST_FAILED')) {
        message = " please check your internet connection";
      }
    }

    return {'success': !hassError, 'message': message};
  }

  // create user obj based on firebase user
  UserModel _userFromFirebase(FirebaseUser user) {
    return user != null ? UserModel(user.uid) : null;
  }

  // auth change user stream
  Stream<UserModel> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // collection reference
  final CollectionReference userCollction =
      Firestore.instance.collection('users');

  Future<void> updateUserData(uid, email, firstName, lastName, phone) async {
    return await userCollction.document(uid).setData({
      'id': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'isAdmin': false,
    });
  }

  Future<void> updateUser(uid, email, firstName, lastName, phone) async {
    return await userCollction.document(uid).updateData({
      'id': uid ?? uid,
      'email': email ?? email,
      'firstName': firstName ?? firstName,
      'lastName': lastName ?? lastName,
      'phone': phone ?? phone,
      'isAdmin': false,
    });
  }

  Future<void> updateUserToAdmin(uid) async {
    return await userCollction.document(uid).updateData({
      'isAdmin': true,
    });
  }

  Future<void> deleteUser(uid) async {
    await userCollction.document(uid).delete();
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      user.delete();
    }
  }

  // Users list from snapshot
  List<UserData> userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print(doc.data);
      return UserData(
        uid: doc.data['id'],
        firstName: doc.data['firstName'],
        lastName: doc.data['lastName'],
        email: doc.data['email'],
        phone: doc.data['phone'],
      );
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.data['id'],
      firstName: snapshot.data['firstName'],
      lastName: snapshot.data['lastName'],
      email: snapshot.data['email'],
      phone: snapshot.data['phone'],
    );
  }

  // get Users stream
  Stream<List<UserData>> get users {
    return userCollction.snapshots().map(userListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollction.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream get singleUser {
    return userCollction.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
