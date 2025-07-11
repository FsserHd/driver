
class ChatRequest {
  String? orderId;
  String? message;
  String? type;
  String? sender;

  ChatRequest({this.orderId, this.message, this.type});

  ChatRequest.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    message = json['message'];
    type = json['type'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['message'] = this.message;
    data['type'] = this.type;
    data['sender'] = this.sender;
    return data;
  }
}
