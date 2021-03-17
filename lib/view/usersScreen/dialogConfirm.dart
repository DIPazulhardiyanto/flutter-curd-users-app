import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/model/User/User.dart';

class DialogConfirm extends StatelessWidget {
  final UserList listItem;
  final UserBloc userBloc;

  DialogConfirm({this.userBloc, this.listItem});

  @override
  Widget build(BuildContext context) {
    var dialogConfirmDelete = Platform.isIOS ? andoidVersion() : iosVersion();

    if (dialogConfirmDelete != null && dialogConfirmDelete) {
      userBloc.add(DeleteUser(user: listItem));
    }
  }

  andoidVersion() {
    return true;
  }

  iosVersion() {
    return false;
  }
}
