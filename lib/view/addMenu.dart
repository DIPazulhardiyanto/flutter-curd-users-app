import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/service/ApiService.dart';
import 'package:sportsapp/view/home.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldEmailValid;
  bool _isFieldPasswordValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Form Add",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                nameField(),
                emailField(),
                passwordField(),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_isFieldNameValid == null ||
                          _isFieldEmailValid == null ||
                          _isFieldPasswordValid == null ||
                          !_isFieldNameValid ||
                          !_isFieldEmailValid ||
                          !_isFieldPasswordValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Please fill all field"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String name = _controllerName.text.toString();
                      String email = _controllerEmail.text.toString();
                      String password = _controllerPassword.text.toString();
                      UserList listUser = UserList(
                          name: name, email: email, password: password);
                      _apiService
                          .createProfile(listUser.toJson())
                          .then((isSuccess) {
                        setState(() => _isLoading = false);
                        if (isSuccess) {
                          Navigator.pop(_scaffoldState.currentState.context);
                        } else {
                          _scaffoldState.currentState.showSnackBar(
                              SnackBar(content: Text("Submit Failed")));
                        }
                      });
                    },
                    child: Text(
                      "Submit".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.orange[600],
                  ),
                ),
                _isLoading
                    ? Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.3,
                            child: ModalBarrier(
                              dismissible: false,
                              color: Colors.grey,
                            ),
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }



  Widget nameField() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Fullname',
          errorText: _isFieldNameValid == null || _isFieldNameValid
              ? null
              : "Fullname Is Required"),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget emailField() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Email',
          errorText: _isFieldEmailValid == null || _isFieldEmailValid
              ? null
              : "Email Is Required"),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget passwordField() {
    return TextField(
      controller: _controllerPassword,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          labelText: 'Password',
          errorText: _isFieldPasswordValid == null || _isFieldPasswordValid
              ? null
              : "Password Is Required"),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPasswordValid) {
          setState(() => _isFieldPasswordValid = isFieldValid);
        }
      },
    );
  }
} //EndClass
