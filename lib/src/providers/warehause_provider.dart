import 'dart:convert';

import 'package:eagon_bodega/src/config/enviroment_config.dart';
import 'package:eagon_bodega/src/models/warehouse_model.dart';
import 'package:eagon_bodega/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class WareHouseProvider{
  final String _url = EnviromentConfig().getApiUrl();
  final prefs  = new PreferenciasUsuario();

  Future<WareHouseModel> getWareHouseList() async{
    
    var uri = Uri.parse('$_url/outgoing.php/getWareHouseList');
    Map<String, String> headers = {
      "content-type"  : "application/x-www-form-urlencoded",
      'Authorization' : EnviromentConfig().getApiKey(),
      'ci_session'    : prefs.ciSession
    };

    var data;
    try{
      
      final resp = await http.get(uri, headers: headers);
      data = Utf8Codec().decode(resp.bodyBytes);
      final warehouse = WareHouseModel.fromJson(jsonDecode(data));

      return warehouse;
      //return warehouse;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }
}