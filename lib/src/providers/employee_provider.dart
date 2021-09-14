import 'dart:convert';

import 'package:eagon_bodega/src/config/enviroment_config.dart';
import 'package:eagon_bodega/src/models/employee_model.dart';
import 'package:eagon_bodega/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class EmployeeProvider{
  final String _url = EnviromentConfig().getApiUrl();
  final prefs  = new PreferenciasUsuario();

  Future<List<EmployeeModel>> getEmployeeList() async{
    
    var uri = Uri.parse('$_url/outgoing.php/getEmployeeList');
    Map<String, String> headers = {
      "content-type"  : "application/x-www-form-urlencoded",
      'Authorization' : EnviromentConfig().getApiKey(),
      'ci_session'    : prefs.ciSession
    };

    var data;
    try{
      
      final resp = await http.get(uri, headers: headers);
      data = Utf8Codec().decode(resp.bodyBytes);
      Iterable it = jsonDecode(data);
      //List<Post> posts = List<Post>.from(l.map((model)=> Post.fromJson(model)));

      List<EmployeeModel> employeeList = List<EmployeeModel>.from(it.map((model) => EmployeeModel.fromJson(model)));

      return employeeList;
      //return warehouse;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }
}