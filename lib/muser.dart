class Muser {
  String name;
  String url;
  String uid;
  String msg;
  String dateTime;

  Muser({this.name, this.url, this.uid, this.msg, this.dateTime});

  Muser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    uid = json['uid'];
    msg = json['msg'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    data['uid'] = this.uid;
    data['msg'] = this.msg;
    data['dateTime'] = this.dateTime;

    return data;
  }
}
