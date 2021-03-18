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
        if (resultUsers.data.totalItems > 0) {
          yield SuccessLoadUsers(responseRow);
        } else {
          yield EmptyDataLoadUsers();
        }
      } catch (e) {
        FailureLoadAllUserState(e);
      }

    } else if (event is PostUser) {
      try{
        bool  response =  await userRepository.fetchCreateUsers(event.user);
        yield SuccessSubmitUserState();

      } catch(e) {
        yield UserErrorState(errorMessage: e.toString());
      }

    } else if (event is DeleteUser) {
      try {
        await userRepository.fetchDeleteUsers(event.user);
        yield UserErrorState(errorMessage: 'Success Delete ${event.user.name}');
        UserResult resultUsers = await userRepository.fetchAllUser();
        List<UserList> responseRow = resultUsers.data.rows;
        yield SuccessLoadUsers(responseRow);
      } catch (e) {
        yield UserErrorState(errorMessage: e.toString());
      }
    } else if (event is GetUpdate) {
      yield Loading();
      print('JALAN ${event}');
      UserResult resultUsers = await userRepository.fetchAllUser();
      List<UserList> responseRow = resultUsers.data.rows;
      yield SuccessLoadUsers(responseRow);
    }
  }
}

