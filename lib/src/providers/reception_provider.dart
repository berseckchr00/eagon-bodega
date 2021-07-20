
import 'dart:convert';

import 'package:eagon_bodega/src/models/dte_model.dart';
import 'package:eagon_bodega/src/models/purchase_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:eagon_bodega/src/config/enviroment_config.dart';
import 'package:eagon_bodega/src/shared_preferences/user_preferences.dart';

class ReceptionProvider{
  
  final String _url = EnviromentConfig().getApiUrl();
  final prefs  = new PreferenciasUsuario();
  final _limit = 5;
  final _start = 1;

  Future<DteModel> getDteList() async{
    
    var uri = Uri.parse('$_url/reception.php/getDteList/$_limit/$_start');
    Map<String, String> headers = {
      "content-type"  : "application/x-www-form-urlencoded",
      'Authorization' : EnviromentConfig().getApiKey(),
      'ci_session'    : prefs.ciSession
    };

    var data;
    try{
      
      final resp = await http.get(uri, headers: headers);
      data = Utf8Codec().decode(resp.bodyBytes);
      print(data);
      final dte = DteModel.fromJson(jsonDecode(data));
      return dte;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }

  Future<DteModel> getDteDetail(String rut, String folio) async{
    
    var uri = Uri.parse('$_url/reception.php/getDteDetail/$rut/$folio');
    Map<String, String> headers = {
      "content-type"  : "application/x-www-form-urlencoded",
      'Authorization' : EnviromentConfig().getApiKey(),
      'ci_session'    : prefs.ciSession
    };

    var data;
    try{
      
      final resp = await http.get(uri, headers: headers);
      data = Utf8Codec().decode(resp.bodyBytes);
      final dte = DteModel.fromJson(jsonDecode(data));
      return dte;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }

  Future<PurchaseOrderModel> getOc(String nmro_oc) async{
    
    var uri = Uri.parse('$_url/reception.php/getDocumentOcList/$nmro_oc');
    Map<String, String> headers = {
      "content-type"  : "application/x-www-form-urlencoded",
      'Authorization' : EnviromentConfig().getApiKey(),
      'ci_session'    : prefs.ciSession
    };

    var data;
    try{
      
      final resp = await http.get(uri, headers: headers);
      data = Utf8Codec().decode(resp.bodyBytes);
      print(data);
      final oc = PurchaseOrderModel.fromJson(jsonDecode(data));
      return oc;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }

  Future<List<Detail>> getOcListDetail(String nmro_oc) async{
    
    var uri = Uri.parse('$_url/reception.php/getDocumentOcList/$nmro_oc');
    Map<String, String> headers = {
      "content-type"  : "application/x-www-form-urlencoded",
      'Authorization' : EnviromentConfig().getApiKey(),
      'ci_session'    : prefs.ciSession
    };

    var data;
    try{
      
      final resp = await http.get(uri, headers: headers);
      data = Utf8Codec().decode(resp.bodyBytes);
      print(data);
      final oc = PurchaseOrderModel.fromJson(jsonDecode(data));
      return oc.data.details;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }
}