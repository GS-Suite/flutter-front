class ClassroomDetails {
  bool success;
  String message;
  String token;
  Data data;

  ClassroomDetails({this.success, this.message, this.token, this.data});

  ClassroomDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String name;
  String uid;
  Null entryCode;

  Data({this.name, this.uid, this.entryCode});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    entryCode = json['entry_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['uid'] = this.uid;
    data['entry_code'] = this.entryCode;
    return data;
  }
}
