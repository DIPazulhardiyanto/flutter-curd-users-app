import 'package:flutter/material.dart';
import 'package:sportsapp/model/User/User.dart';

abstract class UserState {
  final List<UserList> rows;
  final String message;

  UserState({this.rows, this.message});
}

class UserInitalezedState extends UserState {
  @override
  List<UserList> get props => [];
}

class Loading extends UserState{}

class UserErrorState extends UserState {
  UserErrorState({String errorMessage}) : super(message: errorMessage);
}

class UserListLoaded extends UserState {
  UserListLoaded({List<UserList> rows}) : super(rows: rows);
}
