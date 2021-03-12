import 'package:http/http.dart' show Client;
import 'package:sportsapp/model/User/User.dart';
import 'dart:convert';

class ApiService {
  final String _endpoint = "http://192.168.100.5:8000/auth";
  Client client = Client();

  Future<UserResult> getUsers() async {
    final response = await client.get('$_endpoint/users?page=1&size=5&email=&descending=false');
    if (response.statusCode == 200){
      Map valueMap = json.decode(response.body);
      return UserResult.fromJson(valueMap);
    } else {
      return null;
    }
  }

}


