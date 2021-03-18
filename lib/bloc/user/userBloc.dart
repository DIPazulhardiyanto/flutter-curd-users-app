import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/eventUser.dart';
import 'package:sportsapp/bloc/user/stateUser.dart';
import 'package:sportsapp/model/Request/paramsUser.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/repository/repository.dart';
import 'package:sportsapp/service/ApiService.dart';
import 'bloc.dart';
import 'dart:async';
import 'dart:convert';

class UserBloc extends Bloc<UserEvent, UserState> {
  final userRepository = UserRepository();
  final apiService = ApiService();

  @override
  UserState get initialState => UserInitialState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    Object dataParams;

    if (event is GetUsersNextPage) {
      await Future.delayed(Duration(seconds: 2));
      final nextSizePage = 5;
      addSizeData(SuccessLoadUsers state, ) {
        int addSize = nextSizePage + state.listUser.length;
        return addSize;
      }
      dataParams = {"size": addSizeData(state), "search": ""};
      UserParams paramsGet = UserParams.fromJson(dataParams);
      UserResult resultUsers = await userRepository.fetchAllUser(paramsGet);
      List<UserList> responseRow = resultUsers.data.rows;

      if (resultUsers.data.totalItems > 0) {
        yield SuccessLoadUsers(
            totalItems: resultUsers.data.totalItems,
            currentPages: resultUsers.data.currentPage,
            totalPages: resultUsers.data.totalPages,
            listUser: responseRow,
            hasReachedMax: false);
      } else {
        yield EmptyDataLoadUsers();
      }
    } else if (event is GetUsers) {
      yield Loading();
      try {
        dataParams = {"size": event.size, "search": event.search};
        UserParams paramsGet = UserParams.fromJson(dataParams);

        UserResult resultUsers = await userRepository.fetchAllUser(paramsGet);
        List<UserList> responseRow = resultUsers.data.rows;

        if (resultUsers.data.totalItems > 0) {
          yield SuccessLoadUsers(
              totalItems: resultUsers.data.totalItems,
              currentPages: resultUsers.data.currentPage,
              totalPages: resultUsers.data.totalPages,
              listUser: responseRow,
              hasReachedMax: false);
        } else {
          yield EmptyDataLoadUsers();
        }
      } catch (e) {
        FailureLoadAllUserState(e);
      }
    } else if (event is PostUser) {
      yield Loading();
      try {
        bool response = await userRepository.fetchCreateUsers(event.user);
        yield SuccessSubmitUserState();
      } catch (e) {
        yield UserErrorState(errorMessage: e.toString());
      }
    } else if (event is DeleteUser) {
      yield Loading();
      try {
        await userRepository.fetchDeleteUsers(event.user);
        yield UserErrorState(errorMessage: 'Success Delete ${event.user.name}');
        dataParams = {"size": 5, "search": ""};
        UserParams paramsGet = UserParams.fromJson(dataParams);
        UserResult resultUsers = await userRepository.fetchAllUser(paramsGet);
        List<UserList> responseRow = resultUsers.data.rows;
        if (resultUsers.data.totalItems > 0) {
          yield SuccessLoadUsers(
              totalItems: resultUsers.data.totalItems,
              currentPages: resultUsers.data.currentPage,
              totalPages: resultUsers.data.totalPages,
              listUser: responseRow,
              hasReachedMax: false);
        } else {
          yield EmptyDataLoadUsers();
        }
      } catch (e) {
        yield UserErrorState(errorMessage: e.toString());
      }
    } else if (event is GetUpdate) {
      yield Loading();
      // UserResult resultUsers = await userRepository.fetchAllUser();
      // List<UserList> responseRow = resultUsers.data.rows;
      // yield SuccessLoadUsers(listUser: responseRow, hasReachedMax: false);
    }
  }
}
