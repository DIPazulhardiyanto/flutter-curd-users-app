import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/repository/repository.dart';
import 'package:sportsapp/service/ApiService.dart';
import 'package:sportsapp/view/addMenu.dart';
import 'dart:convert';

import 'package:sportsapp/view/usersScreen/cardListUser.dart';

class UserScreen extends StatefulWidget {
  final UserRepository userRepository;

  UserScreen({this.userRepository});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserBloc userBloc;
  TextEditingController _searchController = new TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    UserBloc(UserInitalezedState())..add(GetUsers());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(UserInitalezedState())..add(GetUsers()),
      child: Scaffold(
        appBar: AppBar(
            title: TextField(
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
              hintText: 'Search ...'),
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
              UserBloc(UserInitalezedState())..add(GetUsers());
            },
            child: Center(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return CircularProgressIndicator();
                  } else if (state is UserListLoaded) {
                    List<UserList> listUser = state.rows;
                    return Container(
                      child: (state.rows.isNotEmpty
                          ? CardListUser(listItem: listUser)
                          : Text(
                              'No Data In States',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )),
                    );
                  } else {
                    return Center(
                      child: Container(
                        child: Text(
                          'No Content InSide',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                },
              ),
            )),
      ),
    );
  }
}
