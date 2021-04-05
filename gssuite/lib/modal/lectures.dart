class Lecture {
  bool success;
  String message;
  String token;
  List<Data> data;

  Lecture({this.success, this.message, this.token, this.data});

  Lecture.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Id iId;
  String lectureName;
  String lectureLink;
  List<Null> sections;
  String lectureDescription;
  String lectureResources;

  Data(
      {this.iId,
      this.lectureName,
      this.lectureLink,
      this.sections,
      this.lectureDescription,
      this.lectureResources});

  Data.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
    lectureName = json['lecture_name'];
    lectureLink = json['lecture_link'];
    if (json['sections'] != null) {
      sections = new List<Null>();
      json['sections'].forEach((v) {
        // sections.add(new Null.fromJson(v));
      });
    }
    lectureDescription = json['lecture_description'];
    lectureResources = json['lecture_resources'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId.toJson();
    }
    data['lecture_name'] = this.lectureName;
    data['lecture_link'] = this.lectureLink;
    if (this.sections != null) {
      // data['sections'] = this.sections.map((v) => v.toJson()).toList();
    }
    data['lecture_description'] = this.lectureDescription;
    data['lecture_resources'] = this.lectureResources;
    return data;
  }
}

class Id {
  String oid;

  Id({this.oid});

  Id.fromJson(Map<String, dynamic> json) {
    oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$oid'] = this.oid;
    return data;
  }
}
