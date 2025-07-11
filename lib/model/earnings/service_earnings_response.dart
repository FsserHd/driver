

class ServiceEarnings {
  bool? success;
  String? pendingamount;
  String? completedamount;
  List<Datalist>? datalist;
  String? message;

  ServiceEarnings(
      {this.success,
        this.pendingamount,
        this.completedamount,
        this.datalist,
        this.message});

  ServiceEarnings.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    pendingamount = json['pendingamount'];
    completedamount = json['completedamount'];
    if (json['datalist'] != null) {
      datalist = <Datalist>[];
      json['datalist'].forEach((v) {
        datalist!.add(new Datalist.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['pendingamount'] = this.pendingamount;
    data['completedamount'] = this.completedamount;
    if (this.datalist != null) {
      data['datalist'] = this.datalist!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Datalist {
  String? serviceCode;
  String? deliveryfees;
  String? settlement;

  Datalist({this.serviceCode, this.deliveryfees, this.settlement});

  Datalist.fromJson(Map<String, dynamic> json) {
    serviceCode = json['service_code'];
    deliveryfees = json['deliveryfees'];
    settlement = json['settlement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_code'] = this.serviceCode;
    data['deliveryfees'] = this.deliveryfees;
    data['settlement'] = this.settlement;
    return data;
  }
}
