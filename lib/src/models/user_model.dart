// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.userName,
        this.passWord,
        this.status,
        this.msgStatus,
        this.idUser,
        this.idPersonal,
        this.numFicha,
        this.origenType,
        this.ci_session,
    });

    dynamic user;
    dynamic pass;
    String userName;
    String passWord;
    int status;
    String msgStatus;
    dynamic idUser;
    dynamic idPersonal;
    String numFicha;
    String origenType;
    String ci_session;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userName      : json["userName"],
        passWord      : json["passWord"],
        status        : json["Status"],
        msgStatus     : json["MsgStatus"],
        idUser        : json["id_user"],
        idPersonal    : json["id_personal"],
        numFicha      : json["num_ficha"],
        origenType    : json["origen_type"],
        ci_session    : json["ci_session"],
    );

    Map<String, dynamic> toJson() => {
        "userName"      : userName,
        "passWord"      : passWord,
        "Status"        : status,
        "MsgStatus"     : msgStatus,
        "id_user"       : idUser,
        "id_personal"   : idPersonal,
        "num_ficha"     : numFicha,
        "origen_type"   : origenType,
        "ci_session"    : ci_session
    };
}
