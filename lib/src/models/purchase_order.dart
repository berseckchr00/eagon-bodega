// To parse this JSON data, do
//
//     final purchaseOrder = purchaseOrderFromJson(jsonString);

import 'dart:convert';

PurchaseOrder purchaseOrderFromJson(String str) => PurchaseOrder.fromJson(json.decode(str));

String purchaseOrderToJson(PurchaseOrder data) => json.encode(data.toJson());

class PurchaseOrder {
    PurchaseOrder({
        this.data,
    });

    Data data;

    factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.head,
        this.details,
    });

    Head head;
    List<Detail> details;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        head: Head.fromJson(json["head"]),
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "head": head.toJson(),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
    };
}

class Detail {
    Detail({
        this.codigoProducto,
        this.cantidad,
        this.glosa,
        this.codigoProveedor,
    });

    String codigoProducto;
    String cantidad;
    String glosa;
    String codigoProveedor;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        codigoProducto: json["CODIGO_PRODUCTO"],
        cantidad: json["CANTIDAD"],
        glosa: json["GLOSA"],
        codigoProveedor: json["CODIGO_PROVEEDOR"],
    );

    Map<String, dynamic> toJson() => {
        "CODIGO_PRODUCTO": codigoProducto,
        "CANTIDAD": cantidad,
        "GLOSA": glosa,
        "CODIGO_PROVEEDOR": codigoProveedor,
    };
}

class Head {
    Head({
        this.numero,
        this.fecha,
        this.porcentajeAsignado,
    });

    String numero;
    DateTime fecha;
    String porcentajeAsignado;

    factory Head.fromJson(Map<String, dynamic> json) => Head(
        numero: json["Numero"],
        fecha: DateTime.parse(json["fecha"]),
        porcentajeAsignado: json["PorcentajeAsignado"],
    );

    Map<String, dynamic> toJson() => {
        "Numero": numero,
        "fecha": fecha.toIso8601String(),
        "PorcentajeAsignado": porcentajeAsignado,
    };
}
