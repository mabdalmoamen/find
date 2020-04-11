class UserModel {
  final String uid;
  UserModel(this.uid);
}

class UserData {
  final String uid;

  String firstName;
  String lastName;
  String email;
  String phone;
  bool isAdmin;
  UserData(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.isAdmin = false});
}
