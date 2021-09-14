class Timbre {
  DD dD;
  FRMT fRMT;

  Timbre({this.dD, this.fRMT});

  Timbre.fromJson(Map<String, dynamic> json) {
    dD = json['DD'] != null ? new DD.fromJson(json['DD']) : null;
    fRMT = json['FRMT'] != null ? new FRMT.fromJson(json['FRMT']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dD != null) {
      data['DD'] = this.dD.toJson();
    }
    if (this.fRMT != null) {
      data['FRMT'] = this.fRMT.toJson();
    }
    return data;
  }
}

class DD {
  String rE;
  String tD;
  String f;
  String fE;
  String rR;
  String rSR;
  String mNT;
  String iT1;
  CAF cAF;
  String tSTED;

  DD(
      {this.rE,
      this.tD,
      this.f,
      this.fE,
      this.rR,
      this.rSR,
      this.mNT,
      this.iT1,
      this.cAF,
      this.tSTED});

  DD.fromJson(Map<String, dynamic> json) {
    rE = json['RE'];
    tD = json['TD'];
    f = json['F'];
    fE = json['FE'];
    rR = json['RR'];
    rSR = json['RSR'];
    mNT = json['MNT'];
    iT1 = json['IT1'];
    cAF = json['CAF'] != null ? new CAF.fromJson(json['CAF']) : null;
    tSTED = json['TSTED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RE'] = this.rE;
    data['TD'] = this.tD;
    data['F'] = this.f;
    data['FE'] = this.fE;
    data['RR'] = this.rR;
    data['RSR'] = this.rSR;
    data['MNT'] = this.mNT;
    data['IT1'] = this.iT1;
    if (this.cAF != null) {
      data['CAF'] = this.cAF.toJson();
    }
    data['TSTED'] = this.tSTED;
    return data;
  }
}

class CAF {
  String text;

  CAF({this.text});

  CAF.fromJson(Map<String, dynamic> json) {
    text = json['#text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['#text'] = this.text;
    return data;
  }
}

class FRMT {
  String algoritmo;
  String text;

  FRMT({this.algoritmo, this.text});

  FRMT.fromJson(Map<String, dynamic> json) {
    algoritmo = json['@algoritmo'];
    text = json['#text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@algoritmo'] = this.algoritmo;
    data['#text'] = this.text;
    return data;
  }
}
