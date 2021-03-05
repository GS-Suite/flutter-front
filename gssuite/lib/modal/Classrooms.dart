import 'dart:convert';

List<dynamic> classroomsFromJson(String str) =>
    List<dynamic>.from(json.decode(str).map((x) => x));

String classroomsToJson(List<dynamic> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));

class ClassroomsClass {
  ClassroomsClass({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<List<String>> data;

  factory ClassroomsClass.fromJson(Map<String, dynamic> json) =>
      ClassroomsClass(
        success: json["success"],
        message: json["message"],
        data: List<List<String>>.from(
            json["data"].map((x) => List<String>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(
            data.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
