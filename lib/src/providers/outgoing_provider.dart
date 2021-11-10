import 'dart:convert';

import 'package:eagon_bodega/src/config/enviroment_config.dart';
import 'package:eagon_bodega/src/models/ccosto_model.dart';
import 'package:eagon_bodega/src/models/employee_model.dart';
import 'package:eagon_bodega/src/models/item_cost_model.dart';
import 'package:eagon_bodega/src/models/machine_model.dart';
import 'package:eagon_bodega/src/models/ot_model.dart';
import 'package:eagon_bodega/src/models/product_model.dart';
import 'package:eagon_bodega/src/models/response_order_model.dart';
import 'package:eagon_bodega/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class OutgoingProvider{
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

  Future<List<CCostoModel>> getCCostList(idDepartment) async{
    
    var uri = Uri.parse('$_url/outgoing.php/getDepartmentCCosto/$idDepartment');
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

      List<CCostoModel> cCostList = List<CCostoModel>.from(it.map((model) => CCostoModel.fromJson(model)));

      return cCostList;
      //return warehouse;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }

  Future<List<MachineModel>> getMachineList(idDepartment) async{
    
    var uri = Uri.parse('$_url/outgoing.php/getMachineList/$idDepartment');
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

      List<MachineModel> machineList = List<MachineModel>.from(it.map((model) => MachineModel.fromJson(model)));
      //TODO: agregar machine por default
      return machineList;
      //return warehouse;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }

  Future<List<ItemCostModel>> getItemCostList(idDepartment) async{
    
    var uri = Uri.parse('$_url/outgoing.php/getDepartmentItemCostList/$idDepartment');
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

      List<ItemCostModel> itemCostList = List<ItemCostModel>.from(it.map((model) => ItemCostModel.fromJson(model)));

      return itemCostList;
      //return warehouse;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }

  Future<ProductModel> getProduct(productCode) async{
    
    var uri = Uri.parse('$_url/outgoing.php/searchProduct/$productCode');
    Map<String, String> headers = {
      "content-type"  : "application/x-www-form-urlencoded",
      'Authorization' : EnviromentConfig().getApiKey(),
      'ci_session'    : prefs.ciSession
    };

    var data;
    try{
      
      final resp = await http.get(uri, headers: headers);
      data = Utf8Codec().decode(resp.bodyBytes);

      ProductModel product = ProductModel.fromJson(jsonDecode(data));

      return product;
      //return warehouse;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }

  Future<ResponseOrderModel> saveOrder(Map<String,dynamic> jsonData) async{
    
    var uri = Uri.parse('$_url/outgoing.php/saveOrder');
    Map<String, String> headers = {
      "content-type"  : "application/x-www-form-urlencoded",
      'Authorization' : EnviromentConfig().getApiKey(),
      'ci_session'    : prefs.ciSession
    };

    Map<String, String> queryParameters = {
      "jsonData": jsonEncode(jsonData)
    };
    var data;
    try{
      
      final resp = await http.post( uri, body: queryParameters,  headers: headers);
      data = Utf8Codec().decode(resp.bodyBytes);

      ResponseOrderModel response = ResponseOrderModel.fromJson(jsonDecode(data));
      return response;
      //return warehouse;
      //List<Dte> lstDte = new 

    }catch(ex){
      return null;
    }
  }

  Future<OtModel> getOtData(String otNumber) async{
    
    var uri = Uri.parse('$_url/outgoing.php/getOtData/$otNumber');
    Map<String, String> headers = {
      "content-type"  : "application/x-www-form-urlencoded",
      'Authorization' : EnviromentConfig().getApiKey(),
      'ci_session'    : prefs.ciSession
    };

    var data;
    try{
      
      final resp = await http.get( uri, headers: headers);
      data = Utf8Codec().decode(resp.bodyBytes);
      var jsonResponse = jsonDecode(data)[0];
      OtModel order = OtModel.fromJson(jsonResponse);
      return order; 

    }catch(ex){
      return null;
    }
  }

}