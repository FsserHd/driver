class NotificationModel {
  bool? success;
  List<Data>? data;
  String? message;

  NotificationModel({this.success, this.data, this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? saleId;
  String? saleCode;
  String? vendor;
  ShippingAddress? shippingAddress;
  GeneralDetail? generalDetail;
  String? shopName;

  Data(
      {this.saleId,
        this.saleCode,
        this.shippingAddress,
        this.generalDetail,
        this.shopName});

  Data.fromJson(Map<String, dynamic> json) {
    saleId = json['sale_id'];
    saleCode = json['sale_code'];
    vendor = json['vendor'];
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
    generalDetail = json['general_detail'] != null
        ? new GeneralDetail.fromJson(json['general_detail'])
        : null;
    shopName = json['shop_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sale_id'] = this.saleId;
    data['sale_code'] = this.saleCode;
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    if (this.generalDetail != null) {
      data['general_detail'] = this.generalDetail!.toJson();
    }
    data['shop_name'] = this.shopName;
    return data;
  }
}

class ShippingAddress {
  Null? id;
  String? addressSelect;
  double? latitude;
  double? longitude;
  Null? isDefault;
  Null? username;
  String? phone;
  String? userId;

  ShippingAddress(
      {this.id,
        this.addressSelect,
        this.latitude,
        this.longitude,
        this.isDefault,
        this.username,
        this.phone,
        this.userId});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressSelect = json['addressSelect'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDefault = json['isDefault'];
    username = json['username'];
    phone = json['phone'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressSelect'] = this.addressSelect;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isDefault'] = this.isDefault;
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['userId'] = this.userId;
    return data;
  }
}

class GeneralDetail {
  String? storeName;
  String? subtitle;
  String? email;
  String? fssaiNumber;
  String? ownerName;
  String? companyLegalName;
  String? mobile;
  String? alterMobile;
  String? pickupAddress;
  String? latitude;
  String? longitude;
  String? openingTime;
  String? closingTime;
  String? zoneId;
  String? business;
  String? handOverTime;

  GeneralDetail(
      {this.storeName,
        this.subtitle,
        this.email,
        this.fssaiNumber,
        this.ownerName,
        this.companyLegalName,
        this.mobile,
        this.alterMobile,
        this.pickupAddress,
        this.latitude,
        this.longitude,
        this.openingTime,
        this.closingTime,
        this.zoneId,
        this.business,
        this.handOverTime});

  GeneralDetail.fromJson(Map<String, dynamic> json) {
    storeName = json['storeName'];
    subtitle = json['subtitle'];
    email = json['email'];
    fssaiNumber = json['fssaiNumber'];
    ownerName = json['ownerName'];
    companyLegalName = json['companyLegalName'];
    mobile = json['mobile'];
    alterMobile = json['alterMobile'];
    pickupAddress = json['pickupAddress'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    zoneId = json['zoneId'];
    business = json['business'];
    handOverTime = json['handOverTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeName'] = this.storeName;
    data['subtitle'] = this.subtitle;
    data['email'] = this.email;
    data['fssaiNumber'] = this.fssaiNumber;
    data['ownerName'] = this.ownerName;
    data['companyLegalName'] = this.companyLegalName;
    data['mobile'] = this.mobile;
    data['alterMobile'] = this.alterMobile;
    data['pickupAddress'] = this.pickupAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['openingTime'] = this.openingTime;
    data['closingTime'] = this.closingTime;
    data['zoneId'] = this.zoneId;
    data['business'] = this.business;
    data['handOverTime'] = this.handOverTime;
    return data;
  }
}
