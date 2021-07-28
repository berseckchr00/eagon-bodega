class ReceptionResponse {
  int success;
  String msg;
  Errors errors;
  int id;
  List<Data> data;

  ReceptionResponse({this.success, this.msg, this.errors, this.id, this.data});

  ReceptionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    errors =
        json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
    id = json['id'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.errors != null) {
      data['errors'] = this.errors.toJson();
    }
    data['id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Errors {
  String error1;
  String error3;
  String error4;
  String error5;

  Errors({this.error1, this.error3, this.error4, this.error5});

  Errors.fromJson(Map<String, dynamic> json) {
    error1 = json['error 1'];
    error3 = json['error 3'];
    error4 = json['error 4'];
    error5 = json['error 5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error 1'] = this.error1;
    data['error 3'] = this.error3;
    data['error 4'] = this.error4;
    data['error 5'] = this.error5;
    return data;
  }
}

class Data {
  String cODIGOPRODUCTO;
  String cANTIDAD;
  String gLOSA;
  Null cODIGOPROVEEDOR;
  String lINEA;
  Null uNIADINGREOS;

  Data(
      {this.cODIGOPRODUCTO,
      this.cANTIDAD,
      this.gLOSA,
      this.cODIGOPROVEEDOR,
      this.lINEA,
      this.uNIADINGREOS});

  Data.fromJson(Map<String, dynamic> json) {
    cODIGOPRODUCTO = json['CODIGO_PRODUCTO'];
    cANTIDAD = json['CANTIDAD'];
    gLOSA = json['GLOSA'];
    cODIGOPROVEEDOR = json['CODIGO_PROVEEDOR'];
    lINEA = json['LINEA'];
    uNIADINGREOS = json['UNIADINGREOS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO_PRODUCTO'] = this.cODIGOPRODUCTO;
    data['CANTIDAD'] = this.cANTIDAD;
    data['GLOSA'] = this.gLOSA;
    data['CODIGO_PROVEEDOR'] = this.cODIGOPROVEEDOR;
    data['LINEA'] = this.lINEA;
    data['UNIADINGREOS'] = this.uNIADINGREOS;
    return data;
  }
}
