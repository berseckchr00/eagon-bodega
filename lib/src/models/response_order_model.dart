class ResponseOrderModel{

  bool success;
  String msg;
  List<String> errorList;
  String lastId;

  ResponseOrderModel(this.success, this.msg, this.errorList, this.lastId);

  ResponseOrderModel.fromJson(Map<String, dynamic> json) {
    
     this.success = json['success'];
     this.msg = json['msg'];
     this.errorList = ( json['errorList'] != null)? json['errorList']:[];
     this.lastId = json['lastId'];
  }
}