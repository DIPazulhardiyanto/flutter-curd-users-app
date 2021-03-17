import 'package:meta/meta.dart';
import 'package:sportsapp/model/User/User.dart';

@immutable
abstract class UserEvent {}

class GetUsers extends UserEvent {
  final String query;
  GetUsers({this.query});
}

class GetUpdate extends UserEvent {}

class PutUser extends UserEvent {
  final UserList user;
  PutUser({this.user});
}

class PostUser extends UserEvent {
  final UserList user;
  PostUser({this.user});
}

class DeleteUser extends UserEvent {
  final UserList user;
  DeleteUser({this.user});
}
