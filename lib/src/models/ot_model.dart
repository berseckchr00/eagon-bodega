class OtModel {
  String centroCosto;
  String clasificacionTarea;
  String creadoCode;
  String creadoPor;
  String dateCreate;
  String dateUpdate;
  String descripcionActivo;
  String descripciponTarea;
  String fechaOt;
  String fechaTarea;
  String gdi;
  String gdiFecha;
  String gdiNumero;
  String idFracttalData;
  String idOt;
  String idTarea;
  String recursoInventario;
  String solicitadoPor;
  String tareaOriginal;
  String topoDoc;
  String userCreate;
  String userUpdate;
  String vigente;
  List<DETAIL> detail;

  OtModel(
      {
      this.centroCosto,
      this.clasificacionTarea,
      this.creadoCode,
      this.creadoPor,
      this.dateCreate,
      this.dateUpdate,
      this.descripcionActivo,
      this.descripciponTarea,
      this.fechaOt,
      this.fechaTarea,
      this.gdi,
      this.gdiFecha,
      this.gdiNumero,
      this.idFracttalData,
      this.idOt,
      this.idTarea,
      this.recursoInventario,
      this.solicitadoPor,
      this.tareaOriginal,
      this.topoDoc,
      this.userCreate,
      this.userUpdate,
      this.vigente,
      this.detail});

  OtModel.fromJson(Map<String, dynamic> json) {
    centroCosto = json['CENTRO_COSTO'];
    clasificacionTarea = json['CLASIFICACION_TAREA'];
    creadoCode = json['CREADO_CODE'];
    creadoPor = json['CREADO_POR'];
    dateCreate = json['DATECREATE'];
    dateUpdate = json['DATEUPDATE'];
    descripcionActivo = json['DESCRIPCION_ACTIVO'];
    descripciponTarea = json['DESCRIPCIPON_TAREA'];
    fechaOt = json['FECHA_OT'];
    fechaTarea = json['FECHA_TAREA'];
    gdi = json['GDI'];
    gdiFecha = json['GDI_FECHA'];
    gdiNumero = json['GDI_NUMERO'];
    idFracttalData = json['ID_FRACTTALDATA'];
    idOt = json['ID_OT'];
    idTarea = json['ID_TAREA'];
    recursoInventario = json['RECURSO_INVENTARIO'];
    solicitadoPor = json['SOLICITADO_POR'];
    tareaOriginal = json['TAREA_ORIGINAL'];
    topoDoc = json['TIPO_DOC'];
    userCreate = json['USERCREATE'];
    userUpdate = json['USERUPDATE'];
    vigente = json['VIGENTE'];
    if (json['DETAIL'] != null) {
      detail = new List<DETAIL>();
      json['DETAIL'].forEach((v) {
        detail.add(new DETAIL.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CENTRO_COSTO'] = this.centroCosto;
    data['CLASIFICACION_TAREA'] = this.clasificacionTarea;
    data['CREADO_CODE'] = this.creadoCode;
    data['CREADO_POR'] = this.creadoPor;
    data['DATECREATE'] = this.dateCreate;
    data['DATEUPDATE'] = this.dateUpdate;
    data['DESCRIPCION_ACTIVO'] = this.descripcionActivo;
    data['DESCRIPCIPON_TAREA'] = this.descripciponTarea;
    data['FECHA_OT'] = this.fechaOt;
    data['FECHA_TAREA'] = this.fechaTarea;
    data['GDI'] = this.gdi;
    data['GDI_FECHA'] = this.gdiFecha;
    data['GDI_NUMERO'] = this.gdiNumero;
    data['ID_FRACTTALDATA'] = this.idFracttalData;
    data['ID_OT'] = this.idOt;
    data['ID_TAREA'] = this.idTarea;
    data['RECURSO_INVENTARIO'] = this.recursoInventario;
    data['SOLICITADO_POR'] = this.solicitadoPor;
    data['TAREA_ORIGINAL'] = this.tareaOriginal;
    data['TIPO_DOC'] = this.topoDoc;
    data['USERCREATE'] = this.userCreate;
    data['USERUPDATE'] = this.userUpdate;
    data['VIGENTE'] = this.vigente;
    if (this.detail != null) {
      data['DETAIL'] = this.detail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DETAIL {
  String detCant;
  String matDesc;
  String matCod;

  DETAIL({this.detCant, this.matDesc, this.matCod});

  DETAIL.fromJson(Map<String, dynamic> json) {
    detCant = json['DET_CANT'].toString();
    matDesc = json['MAT_DESC'];
    matCod = json['MAT_COD'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DET_CANT'] = this.detCant;
    data['MAT_DESC'] = this.matDesc;
    data['MAT_COD'] = this.matCod;
    return data;
  }
}
