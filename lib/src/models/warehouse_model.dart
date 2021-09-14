class WareHouseModel {
  List<Data> data;

  WareHouseModel({this.data});

  WareHouseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String idBodega;
  String nombre;
  String vigencia;
  String inventario;
  String stock;
  String recepcionPuerto;
  String trasladoBodegas;
  String dateCreate;
  Null ctaCorrienteFlex;
  Null razonSocialFlex;

  Data(
      {this.idBodega,
      this.nombre,
      this.vigencia,
      this.inventario,
      this.stock,
      this.recepcionPuerto,
      this.trasladoBodegas,
      this.dateCreate,
      this.ctaCorrienteFlex,
      this.razonSocialFlex});

  Data.fromJson(Map<String, dynamic> json) {
    idBodega = json['ID_BODEGA'];
    nombre = json['NOMBRE'];
    vigencia = json['VIGENCIA'];
    inventario = json['INVENTARIO'];
    stock = json['STOCK'];
    recepcionPuerto = json['RECEPCION_PUERTO'];
    trasladoBodegas = json['TRASLADO_BODEGAS'];
    dateCreate = json['DATECREATE'];
    ctaCorrienteFlex = json['CTACORRIENTE_FLEX'];
    razonSocialFlex = json['RAZONSOCIAL_FLEX'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_BODEGA'] = this.idBodega;
    data['NOMBRE'] = this.nombre;
    data['VIGENCIA'] = this.vigencia;
    data['INVENTARIO'] = this.inventario;
    data['STOCK'] = this.stock;
    data['RECEPCION_PUERTO'] = this.recepcionPuerto;
    data['TRASLADO_BODEGAS'] = this.trasladoBodegas;
    data['DATECREATE'] = this.dateCreate;
    data['CTACORRIENTE_FLEX'] = this.ctaCorrienteFlex;
    data['RAZONSOCIAL_FLEX'] = this.razonSocialFlex;
    return data;
  }
}
