import 'package:http/http.dart' show Client;
import 'package:sportsapp/model/User/User.dart';
import 'dart:convert';

class ApiService {
  final String _endpoint = "http://192.168.100.5:8000/auth";
  Client client = Client();

  Future<UserResult> getUsers() async {
    final response = await client
        .get('$_endpoint/users?page=1&size=30&email=&descending=true');
    if (response.statusCode == 200) {
      Map valueMap = json.decode(response.body);
      return UserResult.fromJson(valueMap);
    } else {
      return null;
    }
  }

  Future<bool> createProfile(data) async {
    final String encodedData = json.encode(data);
    final response = await client.post('$_endpoint/register',
        headers: {"content-type": "application/json; charset=UTF-8"}, body: encodedData);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
