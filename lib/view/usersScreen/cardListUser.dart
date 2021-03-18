import 'package:flutter/material.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/model/User/User.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sportsapp/view/usersScreen/addEditUser.dart';

class CardListUser extends StatelessWidget {
  final List<UserList> listItem;
  final UserBloc userBloc;
  final SuccessLoadUsers onState;
  final int totalItems;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  CardListUser({this.listItem, this.userBloc, this.onState, this.totalItems}) {
    _scrollController.addListener(_onScroll);
  }

  int addSize = 0;

  void initState() {
    userBloc.add(GetUsers(size: 5, search: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          UserList listUsers = listItem[index];
          addSize = index;
          return index >= listItem.length -1
              ? listItem.length == totalItems  ? listItemUsers(context, listUsers) :  bottomLoader()
              : listItemUsers(context, listUsers);
        },
        itemCount: listItem.length,
        controller: _scrollController,
      ),
    );
  }

  //Method
  onChangesEdit(context, listUsers) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditScreenUser(userList: listUsers),
      ),
    );
    if (result != null) {
      userBloc.add(GetUsers(size: 5, search: ""));
    }
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (maxScroll == currentScroll && addSize + 1 != totalItems) {
        userBloc.add(GetUsersNextPage());
      }
    }
  }

  //Widget
  Widget bottomLoader() {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }

  Widget listItemUsers(context, listUsers) {
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
                    child: Text('Delete'),
                    textColor: Colors.red,
                    onPressed: () async {
                      var dialogConfirmDelete = Platform.isIOS
                          ? await showCupertinoDialog<bool>(
                              context: context,
                              builder: (_) {
                                return CupertinoAlertDialog(
                                  title: Text('Warning'),
                                  content: Text(
                                    'Are you sure you want to delete ${listUsers.name}\'s data?',
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      isDestructiveAction: true,
                                    ),
                                    CupertinoDialogAction(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                          : await showDialog<bool>(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('Warning'),
                                  content: Text(
                                    'Are you sure you want to delete ${listUsers.name}\'s data?',
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                      if (dialogConfirmDelete != null && dialogConfirmDelete) {
                        userBloc.add(DeleteUser(user: listUsers));
                      }
                    },
                  ),
                  FlatButton(
                    onPressed: () {
                      // TODO: do something in here
                      onChangesEdit(context, listUsers);
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
  }
}
