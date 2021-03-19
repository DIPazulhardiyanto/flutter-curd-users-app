import 'package:dio/dio.dart';
import 'package:sportsapp/model/Request/paramsUser.dart';
import 'package:sportsapp/model/User/User.dart';
import 'dart:convert';
import '../service/api_client/dio_client.dart';

class ApiService {
  DioClient dioClient;

  // final String _endpoint = "http://192.168.100.5:8000/auth"; //Home
  final String _endpoint = "http://192.168.20.232:8000/auth"; //Office
  ApiService() {
    var dio = Dio();
    dioClient = DioClient(_endpoint, dio);
  }

  Future<UserResult> getUserById(UserList data) async {
    final response = await dioClient.get('$_endpoint/users/${data.id}');
    if (response.statusCode == 200) {
      Map valueMap = json.decode(response.body);
      return UserResult.fromJson(valueMap);
    } else {
      return null;
    }
  }


  Future<UserResult> getUsers(UserParams data) async {
    try {
      final response = await dioClient
          .get('$_endpoint/users?page=1&size=${data.size}&email=${data.search}&descending=true');
      return UserResult.fromJson(response);
    } catch (e) {
      return e;
    }
  }

  Future<bool> createProfile(data) async {
    final String encodedData = json.encode(data);
    try {
      final response =
          await dioClient.post('$_endpoint/register', data: encodedData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfile(UserList data) async {
    final String encodedData = json.encode(data);
    try {
      final response = await dioClient.put('$_endpoint/users/${data.id}', data: encodedData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProfile(UserList data) async {
    try {
      final response = await dioClient.delete('$_endpoint/users/${data.id}');
      return true;
    } catch (e) {
      return false;
    }
  }
}
