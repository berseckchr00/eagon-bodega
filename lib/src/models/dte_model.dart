// To parse this JSON data, do
//
//     final DteModel = dteFromJson(jsonString);

import 'dart:convert';

DteModel dteFromJson(String str) => DteModel.fromJson(json.decode(str));

String dteToJson(DteModel data) => json.encode(data.toJson());

class DteModel {
    DteModel({
        this.data,
    });

    Data data;

    factory DteModel.fromJson(Map<String, dynamic> json) => DteModel(
        data: (json != null)?Data.fromJson(json["data"]):null,
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.results,
        this.items,
        this.head,
    });

    int results;
    List<Item> items;
    Head head;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        results: json["results"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        head: (json["head"] != null)?Head.fromJson(json["head"]):null,
    );

    Map<String, dynamic> toJson() => {
        "results": results,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "head": head.toJson(),
    };
}

class Head {
    Head({
        this.dteFolio,
        this.rutEmisor,
        this.rznSoc,
        this.fchEmis,
        this.dirOrigen,
        this.ref,
    });

    String dteFolio;
    String rutEmisor;
    String rznSoc;
    DateTime fchEmis;
    String dirOrigen;
    String ref;

    factory Head.fromJson(Map<String, dynamic> json) => Head(
        dteFolio: json["dte_folio"],
        rutEmisor: json["RUTEmisor"],
        rznSoc: json["RznSoc"],
        fchEmis: DateTime.parse(json["FchEmis"]),
        dirOrigen: json["DirOrigen"],
        ref: json["ref"],
    );

    Map<String, dynamic> toJson() => {
        "dte_folio": dteFolio,
        "RUTEmisor": rutEmisor,
        "RznSoc": rznSoc,
        "FchEmis": "${fchEmis.year.toString().padLeft(4, '0')}-${fchEmis.month.toString().padLeft(2, '0')}-${fchEmis.day.toString().padLeft(2, '0')}",
        "DirOrigen": dirOrigen,
        "ref": ref,
    };
}

class Item {
    Item({
        this.id,
        this.dteFolio,
        this.rutEmisor,
        this.rznSoc,
        this.fchEmis,
        this.idDteDetail,
        this.idDteHeader,
        this.nroLinDet,
        this.tpoCodigo,
        this.vlrCodigo,
        this.nmbItem,
        this.dscItem,
        this.qtyItem,
        this.unmdItem,
        this.prcItem,
        this.montoItem,
        this.dateCreate,
        this.dateUpdate,
    });

    String id;
    String dteFolio;
    String rutEmisor;
    String rznSoc;
    DateTime fchEmis;
    String idDteDetail;
    String idDteHeader;
    String nroLinDet;
    String tpoCodigo;
    String vlrCodigo;
    String nmbItem;
    String dscItem;
    String qtyItem;
    String unmdItem;
    String prcItem;
    String montoItem;
    DateTime dateCreate;
    DateTime dateUpdate;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"] == null ? null:json["id"],
        dteFolio: json["dte_folio"] == null ? null:json["dte_folio"],
        rutEmisor: json["RUTEmisor"] == null ? null:json["RUTEmisor"],
        rznSoc: json["RznSoc"] == null ? null:json["RznSoc"],
        fchEmis: json["FchEmis"] == null ? DateTime.parse('2020-01-01'):DateTime.parse(json["FchEmis"]),
        idDteDetail: json["ID_DTE_DETAIL"] == null ? null : json["ID_DTE_DETAIL"],
        idDteHeader: json["ID_DTE_HEADER"] == null ? null : json["ID_DTE_HEADER"],
        nroLinDet: json["NroLinDet"] == null ? null : json["NroLinDet"],
        tpoCodigo: json["TpoCodigo"] == null ? null : json["TpoCodigo"],
        vlrCodigo: json["VlrCodigo"] == null ? null : json["VlrCodigo"],
        nmbItem: json["NmbItem"] == null ? null : json["NmbItem"],
        dscItem: json["DscItem"] == null ? null : json["DscItem"],
        qtyItem: json["QtyItem"] == null ? null : json["QtyItem"],
        unmdItem: json["UnmdItem"] == null ? null : json["UnmdItem"],
        prcItem: json["PrcItem"] == null ? null : json["PrcItem"],
        montoItem: json["MontoItem"] == null ? null : json["MontoItem"],
        dateCreate: json["Date_Create"] == null ? DateTime.parse('2020-01-01') : DateTime.parse(json["Date_Create"]),
        dateUpdate: json["Date_Update"] == null ? DateTime.parse('2020-01-01') : DateTime.parse(json["Date_Update"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "dte_folio": dteFolio,
        "RUTEmisor": rutEmisor,
        "RznSoc": rznSoc,
        "FchEmis": "${fchEmis.year.toString().padLeft(4, '0')}-${fchEmis.month.toString().padLeft(2, '0')}-${fchEmis.day.toString().padLeft(2, '0')}",
        "ID_DTE_DETAIL": idDteDetail == null ? null : idDteDetail,
        "ID_DTE_HEADER": idDteHeader == null ? null : idDteHeader,
        "NroLinDet": nroLinDet == null ? null : nroLinDet,
        "TpoCodigo": tpoCodigo == null ? null : tpoCodigo,
        "VlrCodigo": vlrCodigo == null ? null : vlrCodigo,
        "NmbItem": nmbItem == null ? null : nmbItem,
        "DscItem": dscItem == null ? null : dscItem,
        "QtyItem": qtyItem == null ? null : qtyItem,
        "UnmdItem": unmdItem == null ? null : unmdItem,
        "PrcItem": prcItem == null ? null : prcItem,
        "MontoItem": montoItem == null ? null : montoItem,
        "Date_Create": dateCreate == null ? null : dateCreate.toIso8601String(),
        "Date_Update": dateUpdate == null ? null : dateUpdate.toIso8601String(),
    };
}
