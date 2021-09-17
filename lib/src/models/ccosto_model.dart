class CCostoModel{
  String cCostoCode;
  String dateCreate;
  String dateUpdate;
  String department;
  String idDepartment;
  String idDocCcosto;
  String userCreate;
  String userUpdate;
  String valid;

  CCostoModel(this.cCostoCode, this.dateCreate, this.dateUpdate, this.department, this.idDepartment, this.idDocCcosto, this.userCreate, this.userUpdate, this.valid);

  @override
  String toString() => this.cCostoCode;

  CCostoModel.fromJson(Map<String, dynamic> json) {
    this.cCostoCode = json['CCOSTO_CODE'];
    this.dateCreate = json['DATECREATE'];
    this.dateUpdate = json['DATEUPDATE'];
    this.department = json['DEPARTAMENTO'];
    this.idDepartment = json['ID_DEPARTAMENTO'];
    this.idDocCcosto = json['ID_DOC_CCOSTO'];
    this.userCreate = json['USERCREATE'];
    this.userUpdate = json['USERUPDATE'];
    this.valid = json['VALID'];
  }
}