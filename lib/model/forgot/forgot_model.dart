
class ForgotModel {
  bool? success;
  int? otp;
  String? message;

  ForgotModel({this.success, this.otp, this.message});

  ForgotModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    otp = json['otp'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['otp'] = this.otp;
    data['message'] = this.message;
    return data;
  }
}
