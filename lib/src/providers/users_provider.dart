
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eagon_bodega/src/models/user_model.dart';
import 'package:eagon_bodega/src/utils/string_utils.dart';
import 'package:eagon_bodega/src/config/enviroment_config.dart';
import 'package:eagon_bodega/src/shared_preferences/user_preferences.dart';

class UserProvider{


  final String _url = EnviromentConfig().getApiUrl();
  final prefs = new PreferenciasUsuario();

  Future<UserModel> getUserLogin(UserModel user) async{
    //var url = '$_url/login.php/login';
    var uri = Uri.parse('$_url/login.php/login');
    Map<String, String> headers = {
      "content-type": "application/x-www-form-urlencoded",
      'Authorization': EnviromentConfig().getApiKey()
    };
    Map<String, String> queryParameters = {
      "user": user.user,
      "pass": user.pass
    };

    var data;

    try{
 

      final resp = await http.post( uri, body: queryParameters,  headers: headers);

      data = Utf8Codec().decode(resp.bodyBytes);
      
      if (!isJson(data)) return null;

      final validJson = jsonDecode(data);
      final userData = UserModel.fromJson(validJson);
      prefs.ciSession = userData.ci_session;

      print(prefs.ciSession);
      return userData;
    } on FormatException catch (e) {
      print(e);
      return null;
    }
  }

  String getUrl(){
    return this._url;
  }

  Future sleep2() {
    return new Future.delayed(const Duration(seconds: 2), () => "2");
  }
  /*final String _url2 = 'http://200.54.216.196/intranet2/index.php/auth';


  Future<UserModel> getUserLoginGet(UserModel user) async{
    
    dynamic userName = user.idUser;
    String passWord = user.passWord;

    var uri = Uri.parse('$_url2/login_api?user=$userName&pass=$passWord');

    final response = await http.get(uri);

    //al realizar el primer response.body se cae
    
    final Map<String, dynamic> data = json.decode(response.body.toString());

    if (data == null) return null;

    final userData = UserModel.fromJson(data);

    print(data);
    print(userData);
    return userData;
  }*/
}