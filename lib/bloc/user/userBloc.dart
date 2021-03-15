import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/eventUser.dart';
import 'package:sportsapp/bloc/user/stateUser.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/repository/repository.dart';
import 'bloc.dart';
import 'dart:async';

class UserBloc extends Bloc<UserEvent, UserState> {
  final _userRepository = UserRepository();

  UserBloc(UserState initialState) : super(null);

  UserState get initialState => UserInitalezedState();


  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    yield Loading();
    if (event is GetUsers) {
      try {
        UserResult resultUsers = await _userRepository.fetchAllUser();
        List<UserList> responseRow = resultUsers.data.rows;
        yield UserListLoaded(rows: responseRow);
      } catch (e) {
        yield UserErrorState(errorMessage: e.toString());
      }
    } else if (event is DeleteUser) {
      try {
        await _userRepository.fetchDeleteUsers(event.user);
        UserBloc(UserInitalezedState())..add(GetUsers());
      } catch (e) {
        yield UserErrorState(errorMessage: e.toString());
      }
    } else if (event is GetUpdate) {
      print('GETUPDATE >>>');
      List<UserList> responseRow = [];
      yield UserListLoaded(rows: responseRow);
    }
  }
}
