import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportsapp/bloc/user/eventUser.dart';
import 'package:sportsapp/bloc/user/stateUser.dart';
import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/repository/repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final _userRespos = UserRepository();

  UserBloc(UserState initialState) : super(
      UserInitalezedState()
  );

  // @override
  // UserState get initialsState => UserInitalezedState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
     yield Loading();
     if (event is GetUsers) {
       try{
         UserResult resultUsers = await _userRespos.fetchAllUser();
         List<UserList> responseRow = resultUsers.data.rows;
         yield UserListLoaded(rows: responseRow);
       } catch(e) {
         yield UserErrorState(errorMessage: e.toString());
       }
     } else if (event is DeleteUser) {
       try {
         await _userRespos.fetchDeleteUsers(UserList());
       } catch(e) {
         yield UserErrorState(errorMessage: e.toString());
       }
     }
  }
}