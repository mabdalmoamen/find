import 'package:find/model/auth-mode.dart';
import 'package:find/service/auth.dart';
import 'package:find/shared/constants.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailNode = FocusNode();
  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  final _phoneNode = FocusNode();
  final _passwordNode = FocusNode();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loading = false;
  AuthMode _authMode = AuthMode.Login;
  final AuthService _auth = AuthService();
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false,
    'fisrtName': null,
    'lastName': null,
    'phone': null,
  };
  Widget _buildEmailFeild() {
    return TextFormField(
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
      controller: emailController,
      focusNode: _emailNode,
      onChanged: (value) => _formData['email'] = value,
      decoration:
          textInputDecoration.copyWith(hintText: 'Email', labelText: 'Email'),
    );
  }

  Widget _buildFirstNameFeild() {
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter First Name';
        }
        return null;
      },
      controller: firstNameController,
      focusNode: _firstNameNode,
      onChanged: (value) => _formData['firstName'] = value,
      decoration: textInputDecoration.copyWith(
          hintText: 'First Name', labelText: 'First Name'),
    );
  }

  Widget _buildLastNameFeild() {
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter Last Name';
        }
        return null;
      },
      controller: lastNameController,
      focusNode: _lastNameNode,
      onChanged: (value) => _formData['lastName'] = value,
      decoration: textInputDecoration.copyWith(
          hintText: 'Last Name', labelText: 'Last Name'),
    );
  }

  Widget _buildPhoneFeild() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter Phone';
        }
        return null;
      },
      controller: phoneController,
      focusNode: _phoneNode,
      onChanged: (value) => _formData['phone'] = value,
      decoration: textInputDecoration.copyWith(
          hintText: 'phone', labelText: 'Your Phone'),
    );
  }

  Widget _buildPasswordFeild() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
        return null;
      },
      focusNode: _passwordNode,
      controller: passwordController,
      obscureText: true,
      onSaved: (value) => _formData['password'] = value,
      decoration: textInputDecoration.copyWith(
          hintText: 'Password', labelText: 'Password'),
    );
  }

  Widget _buildConfirmPasswordFeild() {
    return TextFormField(
      decoration: textInputDecoration.copyWith(labelText: 'Confirm Password'),
      obscureText: true,
      validator: (String value) {
        if (passwordController.text != value) {
          return 'Password dosn\'t Match';
        }
        return null;
      },
    );
  }

  _buildSwitchFeild() {
    return SwitchListTile(
      value: _authMode == AuthMode.Login
          ? _formData['acceptTerms'] = true
          : _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _authMode == AuthMode.Login
              ? _formData['acceptTerms'] = true
              : _formData['acceptTerms'] = value;
        });
      },
      title: Text(
        'Accept Terms',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RaisedButton(
            onPressed: () async {
              if (!_formKey.currentState.validate() ||
                  !_formData['acceptTerms']) {
                return;
              }
              setState(() {
                _loading = true;
              });
              _formKey.currentState.save();
              Map<String, dynamic> successInfo;
              successInfo = await _auth.signIn(
                  _formData['email'],
                  _formData['password'],
                  _authMode,
                  _formData['firstName'],
                  _formData['lastName'],
                  _formData['phone']);
              if (!successInfo['success']) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('An error Ocured!'),
                      content: Text(successInfo['message']),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Okay'),
                          onPressed: () {
                            setState(() {
                              _loading = false;
                            });
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              }
            },
            child: Text(
              '${_authMode != AuthMode.Login ? 'Signup' : 'Login'}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: FlatButton(
          child: Text(
              'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
          onPressed: () {
            setState(() {
              _authMode = _authMode == AuthMode.Login
                  ? AuthMode.SignUp
                  : AuthMode.Login;
            });
          },
        ),
        centerTitle: true,
      ),
      body: Container(
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
                _authMode == AuthMode.Login
                    ? Image.asset(
                        'assets/meditation.png',
                        height: 170,
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Find',
                          style: TextStyle(color: Colors.white),
                        )),
                SizedBox(
                  height: 20,
                ),
                _buildEmailFeild(),
                SizedBox(
                  height: 20,
                ),
                _buildPasswordFeild(),
                SizedBox(
                  height: 20,
                ),
                _authMode == AuthMode.SignUp
                    ? Column(
                        children: <Widget>[
                          _buildConfirmPasswordFeild(),
                          SizedBox(
                            height: 20,
                          ),
                          _buildFirstNameFeild(),
                          SizedBox(
                            height: 20,
                          ),
                          _buildLastNameFeild(),
                          SizedBox(
                            height: 20,
                          ),
                          _buildPhoneFeild(),
                          SizedBox(
                            height: 20,
                          ),
                          _buildSwitchFeild(),
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.indigo),
                    color: Colors.white,
                  ),
                  child: _buildSubmitButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
