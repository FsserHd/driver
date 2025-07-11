class LoginResponse {
  bool? success;
  ProfileModel? data;
  String? message;

  LoginResponse({this.success, this.data, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new ProfileModel.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class ProfileModel {
  String? id;
  String? name;
  String? email;
  String? apiToken;
  String? password;
  String? deviceToken;
  String? deliverytype;
  String? gender;
  String? phone;
  String? status;
  String? zoneId;
  bool? auth;
  bool? liveStatus = false;
  bool? approveState;
  String? address;
  String? supportMobile;
  String? supportWhatsapp;
  String? image;
  String? walletAmount;

  ProfileModel(
      {this.id,
        this.name,
        this.email,
        this.apiToken,
        this.password,
        this.deviceToken,
        this.gender,
        this.phone,
        this.status,
        this.auth,
        this.liveStatus,
        this.approveState,
        this.address,
        this.supportMobile,
        this.supportWhatsapp,
        this.image,
        this.walletAmount,this.zoneId});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    apiToken = json['api_token'];
    deliverytype = json['delivery_type'];
    password = json['password'];
    deviceToken = json['device_token'];
    gender = json['gender'];
    phone = json['phone'];
    status = json['status'];
    auth = json['auth'];
    liveStatus = json['liveStatus'];
    approveState = json['approveState'];
    address = json['address'];
    supportMobile = json['support_mobile'];
    supportWhatsapp = json['support_whatsapp'];
    image = json['image'];
    zoneId = json['zone_id'];
    walletAmount = json['walletAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['delivery_type'] = this.deliverytype;
    data['api_token'] = this.apiToken;
    data['password'] = this.password;
    data['device_token'] = this.deviceToken;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['auth'] = this.auth;
    data['liveStatus'] = this.liveStatus;
    data['approveState'] = this.approveState;
    data['address'] = this.address;
    data['support_mobile'] = this.supportMobile;
    data['support_whatsapp'] = this.supportWhatsapp;
    data['image'] = this.image;
    data['walletAmount'] = this.walletAmount;
    return data;
  }
}
