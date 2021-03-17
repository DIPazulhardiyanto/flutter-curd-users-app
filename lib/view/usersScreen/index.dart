import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/bloc/user/userBloc.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sportsapp/view/addMenu.dart';
import 'package:sportsapp/view/usersScreen/cardListUser.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = new TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  UserBloc userBloc;

  @override
  void initState() {
    userBloc = UserBloc();
    userBloc.add(GetUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        appBar: AppBar(
            title: TextField(
          autofocus: false,
          controller: _searchController,
          autocorrect: false,
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: () {
                  //Todo search button
                  // userListBloc.add(GetUsers(query: _searchController.text));
                },
              ),
              hintStyle: TextStyle(color: Colors.white),
              hintText: 'Search ..'),
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            //TodoPushtoFormAddScreen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FormAddScreen()));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            userBloc.add(GetUsers());
            setState(() {});
          },
          child: BlocProvider<UserBloc>(
            create: (context) => userBloc,
            child:
                BlocListener<UserBloc, UserState>(listener: (context, state) {
              if (state is UserErrorState) {
                scaffoldState.currentState
                    .showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            }, child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is Loading) {
                  return Center(
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator()
                        : CircularProgressIndicator(),
                  );
                } else if (state is FailureLoadAllUserState) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else if (state is SuccessLoadUsers) {
                  var listUsers = state.listUser;
                  return CardListUser(
                    listItem: listUsers,
                    userBloc: userBloc,
                  );
                } else {
                  return Center(
                    child: Container(
                      child: Text('Not Found'),
                    ),
                  );
                }
              },
            )),
          ),
        ));
  }
}
