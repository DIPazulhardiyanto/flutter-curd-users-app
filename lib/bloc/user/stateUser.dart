import 'package:flutter/material.dart';
import 'package:sportsapp/model/User/User.dart';

// abstract class UserState {
//   final List<UserList> rows;
//   final String message;
//
//   UserState({this.rows, this.message});
// }

abstract class UserState {}

class UserInitialState extends UserState {}

class Loading extends UserState{}

class SuccessSubmitUserState extends UserState{}

class SuccessLoadUsers extends UserState{
  final List<UserList> listUser;
  final String message;

  SuccessLoadUsers(this.listUser, {this.message});
  @override
  String toString() {
    return 'SuccessLoadUsers{listAllUsers: ${listUser}, message: ${message}';
  }
}

class FailureLoadAllUserState extends UserState {
  final String errorMessage;

  FailureLoadAllUserState(this.errorMessage);

  @override
  String toString() {
    return 'FailureLoadAllProfileState{errorMessage: $errorMessage}';
  }
}

class UserErrorState extends UserState {
  final String errorMessage;
  UserErrorState({this.errorMessage});
  // UserErrorState({String errorMessage}) : super(message: errorMessage);
}

class UserListLoaded extends UserState {
  final List<UserList> listUser;
  UserListLoaded({this.listUser});
  // UserListLoaded({List<UserList> listUser}) : super(rows: rows);
}
