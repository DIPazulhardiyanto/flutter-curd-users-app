
import 'package:sportsapp/model/User/User.dart';

abstract class UserEvent {
  final UserList user;
  final String query;
  UserEvent({this.user, this.query});
}

class GetUsers extends UserEvent {
  GetUsers({String query}) : super(query: query);
}

class DeleteUser extends UserEvent {
  DeleteUser({UserList user}) : super(user: user);
}