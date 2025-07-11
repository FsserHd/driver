


class OrderEarnings {
  bool? success;
  String? pendingamount;
  String? completedamount;
  List<Datalist>? datalist;
  String? message;

  OrderEarnings(
      {this.success,
        this.pendingamount,
        this.completedamount,
        this.datalist,
        this.message});

  OrderEarnings.fromJson(Map<String, dynamic> json) {
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
  String? saleCode;
  String? driverCharge;
  String? settlement;

  Datalist({this.saleCode, this.driverCharge, this.settlement});

  Datalist.fromJson(Map<String, dynamic> json) {
    saleCode = json['sale_code'];
    driverCharge = json['driver_charge'];
    settlement = json['settlement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sale_code'] = this.saleCode;
    data['driver_charge'] = this.driverCharge;
    data['settlement'] = this.settlement;
    return data;
  }
}
