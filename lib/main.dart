import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/bloc.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/view/home.dart';
import 'package:sportsapp/view/usersScreen/index.dart';
import 'package:sportsapp/view/usersScreen/pageIndex.dart';

void main() {
  // runApp(MyApp());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: HomeScreen(),
        // home: PageUserScreen(),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<UserBloc>(
                create: (context) =>
                    UserBloc(UserInitalezedState())..add(GetUsers()))
          ],
          child: PageUserScreen(),
        ));
  }
}
