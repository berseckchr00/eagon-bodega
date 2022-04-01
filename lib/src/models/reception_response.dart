class ReceptionResponse {
  bool success;
  String msg;
  String errors;
  int id;
  List<Data> data;

  ReceptionResponse({this.success, this.msg, this.errors, this.id, this.data});

  ReceptionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    errors = json['errors'];
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
      data['errors'] = this.errors;
    }
    data['id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
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
