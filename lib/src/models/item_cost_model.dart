class ItemCostModel{
  String code;
  String description;
  String idGenTabCod;

  ItemCostModel(this.code, this.description, this.idGenTabCod);

  @override
  String toString() => this.description;

  ItemCostModel.fromJson(Map<String, dynamic> json) {
    this.description  = json['DESCRIPCION']; 
    this.code = json['CODIGO']; 
    this.idGenTabCod  = json['IdGEN_TABCOD']; 
  }
}