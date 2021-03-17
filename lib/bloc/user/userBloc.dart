import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/eventUser.dart';
import 'package:sportsapp/bloc/user/stateUser.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/repository/repository.dart';
import 'package:sportsapp/service/ApiService.dart';
import 'bloc.dart';
import 'dart:async';

class UserBloc extends Bloc<UserEvent, UserState> {
  final userRepository = UserRepository();
  final apiService = ApiService();

  // UserBloc(this.apiService) : super(UserInitialState());
  @override
  UserState get initialState => UserInitialState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    yield Loading();
    if (event is GetUsers) {
      try {
        UserResult resultUsers = await userRepository.fetchAllUser();
        List<UserList> responseRow = resultUsers.data.rows;
        yield UserListLoaded(listUser: responseRow);
      } catch (e) {
        yield UserErrorState(errorMessage: e.toString());
      }

    } else if (event is DeleteUser) {
      try {
        await userRepository.fetchDeleteUsers(event.user);
        UserBloc().add(GetUsers());
      } catch (e) {
        yield UserErrorState(errorMessage: e.toString());
      }
    } else if (event is GetUpdate) {
      UserInitialState();
      yield Loading();
    }
  }
}

