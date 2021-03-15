import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/model/User/User.dart';

class UserListScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  UserBloc userBloc;

  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: TextField(
        controller: _searchController,
        autocorrect: false,
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
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
        },
      ),
      body: Center(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            userBloc.add(GetUsers());
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserListLoaded) {
                return Container(
                  child: (state.rows.isNotEmpty
                      ? ListView.builder(itemBuilder: (context, index) {
                          List<UserList> listUser = state.rows;
                          return _useCard(listUser);
                        })
                      : Center(
                          child: Container(
                            child: Text('Content Not Found'),
                          ),
                        )),
                );
              }
              if (state is UserErrorState) {
                return Center(
                  child: Container(
                    child: Text(
                      '${state.message}',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  // Card _useCard(UserList listUser, BuildContext context) {
  //   return Card(
  //
  //   );
  // }


  Widget _useCard(List<UserList> listUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      listUser[index].name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(listUser[index].email),
                    Text(listUser[index].id.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            // TODO: do something in here
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            // TODO: do something in here
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: listUser.length,
      ),
    );
  }
} //EndClass
