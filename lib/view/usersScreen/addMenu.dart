import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/service/ApiService.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class AddScreenUser extends StatefulWidget {
  UserList userList;

  AddScreenUser({this.userList});

  @override
  _AddScreenUserState createState() => _AddScreenUserState();
}

class _AddScreenUserState extends State<AddScreenUser> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  UserBloc userBloc;

  var isSuccess = false;
  bool successSubmit = false;

  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldEmailValid;
  bool _isFieldPasswordValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    userBloc = UserBloc();
    if (widget.userList != null) {
      _isFieldNameValid = true;
      _isFieldEmailValid = true;
      _isFieldPasswordValid = true;
      _controllerName.text = widget.userList.name;
      _controllerEmail.text = widget.userList.email;
      _controllerPassword.text = widget.userList.password;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (isSuccess) {
            Navigator.pop(context, true);
          }
          return true;
        },
        child: Scaffold(
            key: scaffoldState,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                widget.userList == null ? 'Form Add' : 'Changes Data',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: BlocProvider<UserBloc>(
                create: (context) => userBloc,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          nameField(),
                          emailField(),
                          widget.userList == null
                              ? passwordField()
                              : Container(),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: RaisedButton(
                              onPressed: () async {
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
                                String name = _controllerName.text.toString();
                                String email = _controllerEmail.text.toString();
                                String password =
                                    _controllerPassword.text.toString();
                                var dialogConfirmDelete = Platform.isIOS
                                    ? await showCupertinoDialog<bool>(
                                        context: context,
                                        builder: (_) {
                                          return CupertinoAlertDialog(
                                            title: Text('Warning'),
                                            content: Text(
                                              'Are you sure you want to add new user :  ${name}\'s ?',
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: Text('Delete'),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                                isDestructiveAction: true,
                                              ),
                                              CupertinoDialogAction(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : await showDialog<bool>(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: Text('Warning'),
                                            content: Container(
                                              child: Text(
                                                'Are you sure you want to add new user :  ${name}\'s ?',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                if (dialogConfirmDelete != null &&
                                    dialogConfirmDelete) {
                                  UserList listUser = UserList(
                                      name: name,
                                      email: email,
                                      password: password);

                                  if (widget.userList == null) {
                                    _apiService
                                        .createProfile(listUser.toJson())
                                        .then((isSuccess) {
                                      if (isSuccess) {
                                        userBloc.add(GetUpdate());
                                        Navigator.pop(context, true);
                                        // Navigator.pop(_scaffoldState.currentState.context);
                                      } else {
                                        _scaffoldState.currentState
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text("Submit Failed")));
                                      }
                                    });
                                  } else {
                                    listUser.id = widget.userList.id;
                                    _apiService.updateProfile(listUser).then((isSuccess) {
                                      if (isSuccess) {
                                        userBloc.add(GetUsers());
                                        Navigator.pop(_scaffoldState
                                            .currentState.context);
                                      } else {
                                        _scaffoldState.currentState
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text("update Failed")));
                                      }
                                    });
                                  }


                                  // userBloc.add(GetUpdate());
                                  // Navigator.pop(context, true);
                                }
                              },
                              child: Text(
                                widget.userList == null
                                    ? 'Submit'.toUpperCase()
                                    : 'Update'.toUpperCase(),
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
                ))
            ));


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
