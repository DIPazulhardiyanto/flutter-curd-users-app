import 'package:sportsapp/model/User/User.dart';
import 'package:sportsapp/service/ApiService.dart';

class UserRepository {
  ApiService _apiService = ApiService();

  Future<UserResult> fetchAllUser() => _apiService.getUsers();

  Future fetchUserById(UserList data) => _apiService.getUserById(data);

  Future fetchDeleteUsers(UserList data) => _apiService.deleteProfile(data);

  Future fetchUpdateUsers(UserList data) => _apiService.updateProfile(data);
}