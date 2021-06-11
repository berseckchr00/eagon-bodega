
import 'dart:convert';

import 'package:eagon_bodega/src/shared_preferences/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:eagon_bodega/src/models/user_model.dart';

class UserProvider{

  final String _url = 'http://200.54.216.196/infoela.cl/api_bodega/v1';
  //final _prefs = new PreferenciasUsuario();

  Future<UserModel> getUserLogin(UserModel user) async{
    //var url = '$_url/login.php/login';
    var uri = Uri.parse('$_url/login.php/login');
    Map<String, String> headers = {
      "content-type": "application/x-www-form-urlencoded",
      'Authorization': '767ad943570d6dce845ca37f7dee92f5'
    };
    Map<String, String> queryParameters = {
      "user": user.user,
      "pass": user.pass
    };

    //String payloadAsString = "{\"foo\":\"bar\"}";

    var data;
    try{
      
      final resp = await http.post( uri, body: queryParameters,  headers: headers);

      data = Utf8Codec().decode(resp.bodyBytes);
      
      print(data);
      if (data == null) return null;

      final userData = UserModel.fromJson(jsonDecode(data));

      print(data);
      print(userData);
      
      //_prefs.ciSession = userData.ci_session;

      return userData;
    }catch(e){
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