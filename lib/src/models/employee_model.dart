class EmployeeModel{
  String department;
  String employe;
  String idDocAprove;
  String idDepartment;
  String idPersonal;
  String priority;
  String valid;
  String dateCreated;
  String userCreated;
  String dateUpdate;
  String userUpdate;

  EmployeeModel(this.department, this.employe, this.idDocAprove, this.idDepartment, this.idPersonal, this.priority, this.valid, this.dateCreated, this.userCreated, this.dateUpdate, this.userUpdate);

  @override
  String toString() => this.idDepartment+"_"+this.employe;

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    
    this.department = json['DEPARTAMENTO'];
    this.employe = json['TRABAJADOR'];
    this.idDocAprove = json['ID_DOC_APPROVE'];
    this.idDepartment = json['ID_DEPARTAMENTO'];
    this.idPersonal = json['ID_PERSONAL'];
    this.priority = json['PRIORITY'];
    this.valid = json['VALID'];
    this.dateCreated = json['DATECREATE'];
    this.userCreated = json['USERCREATE'];
    this.dateUpdate = json['DATEUPDATE'];
    this.userUpdate = json['USERUPDATE'];
  }

}