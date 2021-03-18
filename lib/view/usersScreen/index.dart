import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/bloc/user/userBloc.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sportsapp/view/usersScreen/addEditUser.dart';
import 'package:sportsapp/view/usersScreen/cardListUser.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final initialPageSize = 5;
  bool searchOn = true;

  void showSearch() {
    setState(() {
      searchOn = !searchOn;
    });
  }

  TextEditingController _searchController = new TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  UserBloc userBloc;

  @override
  void initState() {
    userBloc = UserBloc();
    userBloc.add(GetUsers(size: initialPageSize, search: ""));
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
            suffixIcon: Container(
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: searchOn,
                    child: IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () {
                        //Todo search button
                        userBloc.add(GetUsers(
                            size: initialPageSize,
                            search: _searchController.text));
                        showSearch();
                      },
                    ),
                  ),
                  Visibility(
                    visible: !searchOn,
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      color: Colors.white,
                      onPressed: () {
                        //Todo search button
                        userBloc.add(GetUsers(
                            size: initialPageSize,
                            search: ""));
                        _searchController.clear();
                        showSearch();
                      },
                    ),
                  ),
                ],
              ),

              // child: IconButton(
              //   icon: Icon(Icons.search),
              //   color: Colors.white,
              //   onPressed: () {
              //     //Todo search button
              //     userBloc.add(GetUsers(
              //         size: initialPageSize, search: _searchController.text));
              //   },
              // ),
            ),
            hintStyle: TextStyle(color: Colors.white),
            hintText: 'Search ..'),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditScreenUser(),
            ),
          );
          if (result != null) {
            userBloc.add(GetUsers(size: initialPageSize, search: ""));
          }
        },
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          // userBloc.add(GetUsers());
          userBloc.add(GetUsers(size: initialPageSize, search: ""));
        },
        child: BlocProvider<UserBloc>(
          create: (context) => userBloc,
          child: BlocListener<UserBloc, UserState>(listener: (context, state) {
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
                    onState: state,
                    totalItems: state.totalItems);
              } else if (state is EmptyDataLoadUsers) {
                return Center(
                  child: Container(
                    child: Text(
                      'No Data ...',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          )),
        ),
      ),
    );
  }
}
