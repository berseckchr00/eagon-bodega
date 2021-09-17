class MachineModel{
  String description;
  String idDepartment;
  String idMachine;
  String machine;

  MachineModel(this.description, this.idDepartment, this.idMachine, this.machine);

  @override
  String toString() => this.machine;
  
  MachineModel.fromJson(Map<String, dynamic> json) {
    this.description  = json['DESCRIPCION']; 
    this.idDepartment = json['ID_DEPARTAMENTO']; 
    this.idMachine  = json['ID_MAQUINA']; 
    this.machine  = json['MAQUINA'];  
  }
}