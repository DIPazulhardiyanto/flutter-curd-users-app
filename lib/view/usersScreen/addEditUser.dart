import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/service/ApiService.dart';
import 'dart:io';

class AddEditScreenUser extends StatefulWidget {
  UserList userList;

  AddEditScreenUser({this.userList});

  @override
  _AddEditScreenUserState createState() => _AddEditScreenUserState();
}

class _AddEditScreenUserState extends State<AddEditScreenUser> {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  UserBloc userBloc;

  /* All Variables Declaration */

  bool isSuccess = false;
  bool successSubmit = false;
  bool _isLoading = false;
  static bool obscureTextPassword = true;
  ApiService _apiService = ApiService();
  bool _isFieldNameValid;
  bool _isFieldEmailValid;
  bool _isFieldPasswordValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  /* All Widgets Declaration */

  Widget _buildWidgetLoading() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (_, state) {
        if (state is Loading) {
          return Container(
            color: Colors.black.withOpacity(.5),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Platform.isIOS
                  ? CupertinoActivityIndicator()
                  : CircularProgressIndicator(),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget nameField() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: 'Full Name',
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(15)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(
              Icons.person,
              color: Colors.blue,
            ),
          ),
          errorText: _isFieldNameValid == null || _isFieldNameValid
              ? null
              : "Fullname Is Required",
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(19.0))),
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
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(15)),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.blue,
          ),
        ),
          errorText: _isFieldEmailValid == null || _isFieldEmailValid
              ? null
              : "Email Is Required",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(19.0)),),
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
      obscureText: obscureTextPassword,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Email Is Required",
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(15)),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
        ),
        suffixIcon: InkWell(
          onTap: () {
            passwordObscureToggles();
          },
          child: (obscureTextPassword)
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(19.0)),
      ),

      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPasswordValid) {
          setState(() => _isFieldPasswordValid = isFieldValid);
        }
      },
    );
  }

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
            key: _scaffoldState,
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
                    _buildWidgetLoading(),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: nameField(),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: emailField(),
                          ),

                          widget.userList == null
                              ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: passwordField(),
                              )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: RaisedButton(
                              onPressed: () async {
                                // Validating Form Input First
                                if (validateFormInput()) {
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
                                              child: Text(widget.userList ==
                                                      null
                                                  ? 'Are you sure you want to ADD NEW user :  ${name}\'s ?'
                                                  : 'Are you sure you want to UPDATE user :  ${name}\'s ?'),
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
                                    onSaveUser(listUser);
                                  } else {
                                    onUpdateUser(listUser);
                                  }
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
                ))));
  }

  /* All Methods Declaration */

  void passwordObscureToggles() {
    print(obscureTextPassword);
    setState(() {
      obscureTextPassword = !obscureTextPassword;
    });
  }

  bool validateFormInput() {
    if (_isFieldNameValid == null ||
        _isFieldEmailValid == null ||
        _isFieldPasswordValid == null ||
        !_isFieldNameValid ||
        !_isFieldEmailValid ||
        !_isFieldPasswordValid) {
      return true;
    } else {
      return false;
    }
  }

  Future waitingFine() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pop(context, true);
  }

  void onSaveUser(dataUser) {
    _apiService.createProfile(dataUser.toJson()).then((isSuccess) {
      if (isSuccess) {
        _scaffoldState.currentState
            .showSnackBar(SnackBar(content: Text("Add New Users Success")));
        waitingFine();
      } else {
        _scaffoldState.currentState
            .showSnackBar(SnackBar(content: Text("Submit Failed")));
      }
    });
  }

  void onUpdateUser(dataUser) {
    dataUser.id = widget.userList.id;
    _apiService.updateProfile(dataUser).then((isSuccess) {
      if (isSuccess) {
        _scaffoldState.currentState
            .showSnackBar(SnackBar(content: Text("Update Users Success")));
        waitingFine();
      } else {
        _scaffoldState.currentState
            .showSnackBar(SnackBar(content: Text("Update Failed")));
      }
    });
  }

} //EndClass
