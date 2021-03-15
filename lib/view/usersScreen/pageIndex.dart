import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/service/ApiService.dart';
import 'package:sportsapp/view/addMenu.dart';

class PageUserScreen extends StatefulWidget {
  @override
  _PageUserScreenState createState() => _PageUserScreenState();
}

class _PageUserScreenState extends State<PageUserScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  UserBloc userBloc;

  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserBloc>(context);
    // userBloc.add(GetUsers());
    return Scaffold(
      key: _scaffoldState,
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FormAddScreen()));
        },
      ),
      body: Center(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            UserBloc(UserInitalezedState())..add(GetUsers());;
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is Loading) {
                return CircularProgressIndicator();
              } else if (state is UserListLoaded) {
                List<UserList> listUser = state.rows;
                return _useCard(listUser);
              } else if (state is UserErrorState) {
                return Center(
                  child: Container(
                    child: Text(
                      '${state.message}',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
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
        ),
      ),
    );
  }

  Widget _useCard(List<UserList> listUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          UserList listUsers = listUser[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      listUsers.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(listUsers.email),
                    Text(listUsers.id.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            // TODO: do something in here
                            UserBloc(UserInitalezedState())
                              ..add(DeleteUser(user: listUsers));
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            // TODO: do something in here
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FormAddScreen(userList: listUsers)));
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
}
