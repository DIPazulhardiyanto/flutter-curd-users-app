import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/service/ApiService.dart';
import 'package:sportsapp/view/addMenu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  ApiService _apiService;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.amber[800].withOpacity(0.5),
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Home Screen",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FormAddScreen()));
                  })
            ],
          ),
          body: Center(
              child: FutureBuilder(
            future: _apiService.getUsers(),
            builder:
                (BuildContext context, AsyncSnapshot<UserResult> snapshot) {
              if (snapshot.hasError) {
                return ErrorMessage();
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<UserList> listUser = snapshot.data.data.rows;
                return _buildUserList(listUser);
              } else {
                return CircularProgressIndicator();
              }
            },
          )),
        ),
        onRefresh: () async {
          _apiService
              .getUsers()
              .then((value) => {setState(() => value.data.rows)});
        }
        );
  }

  Widget ErrorMessage() {
    return Center(
      child: Text('No Content InSide'),
    );
  }

  Widget _buildUserList(List<UserList> listUser) {
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
  } //EndOF_buildUserList
}
