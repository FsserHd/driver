class ServiceResponseModel {
  bool? success;
  List<Service>? data;
  String? message;

  ServiceResponseModel({this.success, this.data, this.message});

  ServiceResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Service>[];
      json['data'].forEach((v) {
        data!.add(new Service.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Service {
  String? id;
  String? serviceCode;
  String? fromname;
  String? fphoneno;
  String? fromtime;
  String? fromlocation;
  String? toname;
  String? tophoneno;
  String? tolocation;
  String? description;
  String? status;
  String? distance1;
  String? deliveryfees;
  String? paymentmode;
  String? userid;
  String? fromLatitude;
  String? fromLongitude;
  String? toLatitude;
  String? otp;
  String? deliveryStatus;
  String? toLongitude;
  String? isAccepted;
  String? types;
  String? createdAt;

  Service(
      {this.id,
        this.fromname,
        this.fphoneno,
        this.fromtime,
        this.fromlocation,
        this.toname,
        this.tophoneno,
        this.tolocation,
        this.description,
        this.status,
        this.distance1,
        this.deliveryfees,
        this.userid,
        this.fromLatitude,
        this.fromLongitude,
        this.toLatitude,
        this.toLongitude,
        this.types,
        this.createdAt,this.deliveryStatus,this.otp,this.serviceCode,this.isAccepted,this.paymentmode});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromname = json['fromname'];
    fphoneno = json['fphoneno'];
    fromtime = json['fromtime'];
    fromlocation = json['fromlocation'];
    toname = json['toname'];
    tophoneno = json['tophoneno'];
    paymentmode = json['paymentmode'];

    tolocation = json['tolocation'];
    description = json['description'];
    status = json['status'];
    distance1 = json['distance1'];
    deliveryfees = json['deliveryfees'];
    serviceCode = json['service_code'];
    userid = json['userid'];
    fromLatitude = json['from_latitude'];
    fromLongitude = json['from_longitude'];
    toLatitude = json['to_latitude'];
    deliveryStatus = json['delivery_status'];
    toLongitude = json['to_longitude'];
    otp = json['otp'];
    types = json['types'];
    createdAt = json['created_at'];
    isAccepted = json['is_accepted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fromname'] = this.fromname;
    data['fphoneno'] = this.fphoneno;
    data['fromtime'] = this.fromtime;
    data['fromlocation'] = this.fromlocation;
    data['toname'] = this.toname;
    data['tophoneno'] = this.tophoneno;

    data['tolocation'] = this.tolocation;
    data['description'] = this.description;
    data['status'] = this.status;
    data['distance1'] = this.distance1;
    data['deliveryfees'] = this.deliveryfees;
    data['userid'] = this.userid;
    data['from_latitude'] = this.fromLatitude;
    data['from_longitude'] = this.fromLongitude;
    data['to_latitude'] = this.toLatitude;
    data['to_longitude'] = this.toLongitude;
    data['types'] = this.types;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Types {
  String? name;
  String? image;

  Types({this.name, this.image});

  Types.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
