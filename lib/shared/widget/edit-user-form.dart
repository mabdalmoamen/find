import 'package:find/model/user.dart';
import 'package:find/service/auth.dart';
import 'package:find/shared/constants.dart';
import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  final String uid;
  EditUser({this.uid});
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  final AuthService _auth = AuthService();
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false,
    'fisrtName': null,
    'lastName': null,
    'phone': null,
  };
  Widget _buildEmailFeild(email) {
    return TextFormField(
      initialValue: email,
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter E-Mail';
        } else if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onChanged: (value) => _formData['email'] = value,
      decoration:
          textInputDecoration.copyWith(hintText: 'Email', labelText: 'Email'),
    );
  }

  Widget _buildFirstNameFeild(firstName) {
    return TextFormField(
      initialValue: firstName,
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter First Name';
        }
        return null;
      },
      onChanged: (value) => _formData['firstName'] = value,
      decoration: textInputDecoration.copyWith(
          hintText: 'First Name', labelText: 'First Name'),
    );
  }

  Widget _buildLastNameFeild(lastName) {
    return TextFormField(
      initialValue: lastName,
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter Last Name';
        }
        return null;
      },
      onChanged: (value) => _formData['lastName'] = value,
      decoration: textInputDecoration.copyWith(
          hintText: 'Last Name', labelText: 'Last Name'),
    );
  }

  Widget _buildPhoneFeild(phone) {
    return TextFormField(
      initialValue: phone,
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter Phone';
        }
        return null;
      },
      onChanged: (value) => _formData['phone'] = value,
      decoration: textInputDecoration.copyWith(
          hintText: 'phone', labelText: 'Your Phone'),
    );
  }

  Widget _buildSubmitButton(id, email, firstName, lastName, phone) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RaisedButton(
            onPressed: () async {
              if (!_formKey.currentState.validate()) {
                return;
              }
              setState(() {
                _loading = true;
              });
              _formKey.currentState.save();
              await _auth.updateUser(
                widget.uid ?? id,
                _formData['email'] ?? email,
                _formData['firstName'] ?? firstName,
                _formData['lastName'] ?? lastName,
                _formData['phone'] ?? phone,
              );
              setState(() {
                _loading = false;
              });
              Navigator.of(context).pop();
            },
            child: Text(
              'Update',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: AuthService(uid: widget.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.black.withOpacity(0.9),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    _buildEmailFeild(userData.email),
                    SizedBox(
                      height: 20,
                    ),
                    _buildFirstNameFeild(userData.firstName),
                    SizedBox(
                      height: 20,
                    ),
                    _buildLastNameFeild(userData.lastName),
                    SizedBox(
                      height: 20,
                    ),
                    _buildPhoneFeild(userData.phone),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo),
                        color: Colors.white,
                      ),
                      child: _buildSubmitButton(
                          userData.uid,
                          userData.email,
                          userData.firstName,
                          userData.lastName,
                          userData.phone),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
