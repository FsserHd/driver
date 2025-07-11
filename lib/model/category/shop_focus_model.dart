class ShopFocusModel {
  bool? success;
  List<ShopFocusData>? data;
  String? message;

  ShopFocusModel({this.success, this.data, this.message});

  ShopFocusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ShopFocusData>[];
      json['data'].forEach((v) {
        data!.add(new ShopFocusData.fromJson(v));
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

class ShopFocusData {
  String? shopFocusId;
  String? title;

  ShopFocusData({this.shopFocusId, this.title});

  ShopFocusData.fromJson(Map<String, dynamic> json) {
    shopFocusId = json['shop_focus_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_focus_id'] = this.shopFocusId;
    data['title'] = this.title;
    return data;
  }
}
