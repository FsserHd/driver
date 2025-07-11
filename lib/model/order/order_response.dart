class OrderResponse {
  bool? success;
  List<OrderDetails>? data;
  String? message;

  OrderResponse({this.success, this.data, this.message});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <OrderDetails>[];
      json['data'].forEach((v) {
        data!.add(new OrderDetails.fromJson(v));
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

class OrderDetails {
  String? userid;
  String? saleCode;
  List<ProductDetails>? productDetails;
  List<Addon>? addonDetails;
  PaymentDetails? paymentDetails;
  Address? address;
  String? shipping;
  String? otp;
  String? paymentType;
  String? paymentStatus;
  String? paymentTimestamp;
  String? grandTotal;
  String? saleDatetime;
  String? orderType;
  String? delivaryDatetime;
  Null? deliverAssignedtime;
  String? deliveryState;
  String? adminforceassigned;
  String? driverCharge;
  Vendor? vendor;

  OrderDetails(
      {this.userid,
        this.saleCode,
        this.productDetails,
        this.paymentDetails,
        this.address,
        this.shipping,
        this.paymentType,
        this.paymentStatus,
        this.paymentTimestamp,
        this.grandTotal,
        this.saleDatetime,
        this.delivaryDatetime,
        this.deliverAssignedtime,
        this.deliveryState,
        this.driverCharge,
        this.vendor,this.otp,this.orderType,this.adminforceassigned,this.addonDetails});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    otp = json['otp'];
    saleCode = json['sale_code'];
    if (json['product_details'] != null) {
      productDetails = <ProductDetails>[];
      json['product_details'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
    paymentDetails = json['payment_details'] != null
        ? new PaymentDetails.fromJson(json['payment_details'])
        : null;
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    shipping = json['shipping'];
    paymentType = json['payment_type'];
    orderType = json['order_type'];
    paymentStatus = json['payment_status'];
    paymentTimestamp = json['payment_timestamp'];
    grandTotal = json['grand_total'];
    saleDatetime = json['sale_datetime'];
    delivaryDatetime = json['delivary_datetime'];
    adminforceassigned = json['adminforceassigned'];
    deliverAssignedtime = json['deliver_assignedtime'];
    deliveryState = json['delivery_state'];
    driverCharge = json['driver_charge'];
    vendor =
    json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
    if (json['addon_details'] != null) {
      addonDetails = <Addon>[];
      json['addon_details'].forEach((v) {
        addonDetails!.add(new Addon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['sale_code'] = this.saleCode;
    if (this.productDetails != null) {
      data['product_details'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    if (this.paymentDetails != null) {
      data['payment_details'] = this.paymentDetails!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['shipping'] = this.shipping;
    data['payment_type'] = this.paymentType;
    data['payment_status'] = this.paymentStatus;
    data['payment_timestamp'] = this.paymentTimestamp;
    data['grand_total'] = this.grandTotal;
    data['sale_datetime'] = this.saleDatetime;
    data['delivary_datetime'] = this.delivaryDatetime;
    data['deliver_assignedtime'] = this.deliverAssignedtime;
    data['delivery_state'] = this.deliveryState;
    data['driver_charge'] = this.driverCharge;
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }

    return data;
  }
}

class Addon {
  String? addonId;
  String? productId;
  String? name;
  String? price;
  String? type;
  int? qty = 0;
  bool? selected;
  String? foodType;

  Addon(
      {this.addonId,
        this.productId,
        this.name,
        this.price,
        this.type,
        this.selected,
        this.foodType});

  Addon.fromJson(Map<String, dynamic> json) {
    addonId = json['addon_id'];
    productId = json['product_id'];
    name = json['name'];
    price = json['price'];
    type = json['type'];
    selected = json['selected'];
    foodType = json['foodType'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addon_id'] = this.addonId;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['type'] = this.type;
    data['selected'] = this.selected;
    data['foodType'] = this.foodType;
    return data;
  }
}

class ProductDetails {
  String? id;
  String? productName;
  String? price;
  String? strike;
  int? offer;
  String? quantity;
  int? qty;
  String? variant;
  String? variantValue;
  String? userId;
  String? cartId;
  String? unit;
  String? shopId;
  String? image;
  double? tax;
  String? discount;
  double? packingCharge;

  ProductDetails(
      {this.id,
        this.productName,
        this.price,
        this.strike,
        this.offer,
        this.quantity,
        this.qty,
        this.variant,
        this.variantValue,
        this.userId,
        this.cartId,
        this.unit,
        this.shopId,
        this.image,
        this.tax,
        this.discount,
        this.packingCharge});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    price = json['price'];
    strike = json['strike'];
    offer = json['offer'];
    quantity = json['quantity'];
    qty = json['qty'];
    variant = json['variant'];
    variantValue = json['variantValue'];
    userId = json['userId'];
    cartId = json['cartId'];
    unit = json['unit'];
    shopId = json['shopId'];
    image = json['image'];
    tax = json['tax'].toDouble();
    discount = json['discount'];
    packingCharge = json['packingCharge'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['strike'] = this.strike;
    data['offer'] = this.offer;
    data['quantity'] = this.quantity;
    data['qty'] = this.qty;
    data['variant'] = this.variant;
    data['variantValue'] = this.variantValue;
    data['userId'] = this.userId;
    data['cartId'] = this.cartId;
    data['unit'] = this.unit;
    data['shopId'] = this.shopId;
    data['image'] = this.image;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['packingCharge'] = this.packingCharge;
    return data;
  }
}

class PaymentDetails {
  Null? id;
  Null? status;
  String? paymentType;
  String? method;
  int? grandTotal;
  int? subTotal;
  String? discount;
  String? km;
  int? deliveryFees;
  int? deliveryTips;
  double? tax;
  double? packingCharge;

  PaymentDetails(
      {this.id,
        this.status,
        this.paymentType,
        this.method,
        this.grandTotal,
        this.subTotal,
        this.discount,
        this.km,
        this.deliveryFees,
        this.deliveryTips,
        this.tax,
        this.packingCharge});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    paymentType = json['paymentType'];
    method = json['method'];
    grandTotal = json['grand_total'];
    subTotal = json['sub_total'];
    discount = json['discount'].toString();
    km = json['km'];
    deliveryFees = json['delivery_fees'];
    deliveryTips = json['delivery_tips'];
    tax = json['tax'].toDouble();
    packingCharge = json['packingCharge'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['paymentType'] = this.paymentType;
    data['method'] = this.method;
    data['grand_total'] = this.grandTotal;
    data['sub_total'] = this.subTotal;
    data['discount'] = this.discount;
    data['km'] = this.km;
    data['delivery_fees'] = this.deliveryFees;
    data['delivery_tips'] = this.deliveryTips;
    data['tax'] = this.tax;
    data['packingCharge'] = this.packingCharge;
    return data;
  }
}

class Address {
  Null? id;
  String? addressSelect;
  double? latitude;
  double? longitude;
  Null? isDefault;
  Null? username;
  String? phone;
  String? userId;

  Address(
      {this.id,
        this.addressSelect,
        this.latitude,
        this.longitude,
        this.isDefault,
        this.username,
        this.phone,
        this.userId});

  Address.fromJson(Map<String, dynamic> json) {
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

class Vendor {
  String? displayName;
  String? latitude;
  String? longitude;
  String? address;
  String? phone;

  Vendor(
      {this.displayName,
        this.latitude,
        this.longitude,
        this.address,
        this.phone});

  Vendor.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['phone'] = this.phone;
    return data;
  }
}
