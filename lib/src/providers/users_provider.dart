
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:eagon_bodega/src/models/user_model.dart';

class UserProvider{

  final String _url = 'http://200.54.216.196/intranet2/index.php/auth';


  Future<UserModel> getUserLogin(UserModel user) async{
    
    String userName = user.idUser;
    String passWord = user.passWord;

    var uri = Uri.parse('$_url/login_api?user=$userName&pass=$passWord');

    final response = await http.get(uri);

    //al realizar el primer response.body se cae
    
    final Map<String, dynamic> data = json.decode(response.body.toString());

    if (data == null) return null;

    final userData = UserModel.fromJson(data);

    print(data);
    print(userData);
    return userData;
  }

}