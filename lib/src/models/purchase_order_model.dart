// To parse this JSON data, do
//
//     final PurchaseOrderModel = purchaseOrderFromJson(jsonString);

import 'dart:convert';

PurchaseOrderModel purchaseOrderFromJson(String str) => PurchaseOrderModel.fromJson(json.decode(str));

String purchaseOrderToJson(PurchaseOrderModel data) => json.encode(data.toJson());

class PurchaseOrderModel {
    PurchaseOrderModel({
        this.data,
    });

    Data data;

    factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) => PurchaseOrderModel(
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
        this.linea,
        this.unidadIngreso
    });

    String codigoProducto;
    String cantidad;
    String glosa;
    String codigoProveedor;
    String linea;
    String unidadIngreso;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        codigoProducto: json["CODIGO_PRODUCTO"],
        cantidad: json["CANTIDAD"],
        glosa: json["GLOSA"],
        codigoProveedor: json["CODIGO_PROVEEDOR"],
        linea: json["LINEA"],
        unidadIngreso: json["UNIDADINGRESO"],
    );

    Map<String, dynamic> toJson() => {
        "CODIGO_PRODUCTO": codigoProducto,
        "CANTIDAD": cantidad,
        "GLOSA": glosa,
        "CODIGO_PROVEEDOR": codigoProveedor,
        "LINEA": linea,
        "UNIADINGREOS": unidadIngreso,
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
