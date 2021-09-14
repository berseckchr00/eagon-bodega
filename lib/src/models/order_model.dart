class OrdersModel {
  String numeroVale;
  String fecha;
  String nombreSolicitante;
  String rutSolicitante;
  String bodega;
  String maquina;
  String centroCosto;
  String itemGasto;
  List<Detalle> detalle;

  OrdersModel(
      {this.numeroVale,
      this.fecha,
      this.nombreSolicitante,
      this.rutSolicitante,
      this.bodega,
      this.maquina,
      this.centroCosto,
      this.itemGasto,
      this.detalle});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    numeroVale = json['numeroVale'];
    fecha = json['fecha'];
    nombreSolicitante = json['nombre_solicitante'];
    rutSolicitante = json['rut_solicitante'];
    bodega = json['bodega'];
    maquina = json['maquina'];
    centroCosto = json['centro_costo'];
    itemGasto = json['item_gasto'];
    if (json['detalle'] != null) {
      detalle = new List<Detalle>();
      json['detalle'].forEach((v) {
        detalle.add(new Detalle.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numeroVale'] = this.numeroVale;
    data['fecha'] = this.fecha;
    data['nombre_solicitante'] = this.nombreSolicitante;
    data['rut_solicitante'] = this.rutSolicitante;
    data['bodega'] = this.bodega;
    data['maquina'] = this.maquina;
    data['centro_costo'] = this.centroCosto;
    data['item_gasto'] = this.itemGasto;
    if (this.detalle != null) {
      data['detalle'] = this.detalle.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detalle {
  String codigoProducto;
  String nombreProducto;
  String cantidad;
  String unidadMedida;

  Detalle(
      {this.codigoProducto,
      this.nombreProducto,
      this.cantidad,
      this.unidadMedida});

  Detalle.fromJson(Map<String, dynamic> json) {
    codigoProducto = json['codigo_producto'];
    nombreProducto = json['nombre_producto'];
    cantidad = json['cantidad'];
    unidadMedida = json['unidad_medida'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo_producto'] = this.codigoProducto;
    data['nombre_producto'] = this.nombreProducto;
    data['cantidad'] = this.cantidad;
    data['unidad_medida'] = this.unidadMedida;
    return data;
  }
}
