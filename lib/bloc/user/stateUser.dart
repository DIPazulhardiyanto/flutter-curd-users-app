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
