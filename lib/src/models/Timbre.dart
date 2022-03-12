// To parse this JSON data, do
//
//     final welcome6 = welcome6FromJson(jsonString);

import 'dart:convert';

Timbre timbreFromJson(String str) => Timbre.fromJson(json.decode(str));

String timbreToJson(Timbre data) => json.encode(data.toJson());

class Timbre {
  Timbre({
    this.ted,
  });

  Ted ted;

  factory Timbre.fromJson(Map<String, dynamic> json) => Timbre(
        ted: Ted.fromJson(json["TED"]),
      );

  Map<String, dynamic> toJson() => {
        "TED": ted.toJson(),
      };
}

class Ted {
  Ted({
    this.dd,
    this.frmt,
  });

  Dd dd;
  String frmt;

  factory Ted.fromJson(Map<String, dynamic> json) => Ted(
        dd: Dd.fromJson(json["DD"]),
        frmt: json["FRMT"],
      );

  Map<String, dynamic> toJson() => {
        "DD": dd.toJson(),
        "FRMT": frmt,
      };
}

class Dd {
  Dd({
    this.re,
    this.td,
    this.f,
    this.fe,
    this.rr,
    this.rsr,
    this.mnt,
    this.it1,
    this.caf,
    this.tsted,
  });

  String re;
  String td;
  String f;
  String fe;
  String rr;
  String rsr;
  String mnt;
  String it1;
  Map<String, dynamic> caf;
  String tsted;

  factory Dd.fromJson(Map<String, dynamic> json) => Dd(
        re: json["RE"],
        td: json["TD"],
        f: json["F"],
        fe: json["FE"],
        rr: json["RR"],
        rsr: json["RSR"],
        mnt: json["MNT"],
        it1: json["IT1"],
        caf: json["CAF"],
        tsted: json["TSTED"],
      );

  Map<String, dynamic> toJson() => {
        "RE": re,
        "TD": td,
        "F": f,
        "FE": fe,
        //"${fe.year.toString().padLeft(4, '0')}-${fe.month.toString().padLeft(2, '0')}-${fe.day.toString().padLeft(2, '0')}",
        "RR": rr,
        "RSR": rsr,
        "MNT": mnt,
        "IT1": it1,
        "CAF": caf,
        "TSTED": tsted,
      };
}
