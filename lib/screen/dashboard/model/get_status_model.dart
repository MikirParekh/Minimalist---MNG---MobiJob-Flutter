class GetStatusModel {
  Data? data;
  String? message;
  Null token;
  bool? completed;

  GetStatusModel({this.data, this.message, this.token, this.completed});

  GetStatusModel.fromJson(Map<String, dynamic> json) {
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
    message = json['Message'];
    token = json['Token'];
    completed = json['Completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    data['Message'] = this.message;
    data['Token'] = this.token;
    data['Completed'] = this.completed;
    return data;
  }
}

class Data {
  String? userId;
  String? userName;
  String? password;
  String? nAVDriverNo;
  bool? status;

  Data(
      {this.userId,
      this.userName,
      this.password,
      this.nAVDriverNo,
      this.status});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    userName = json['UserName'];
    password = json['Password'];
    nAVDriverNo = json['NAVDriverNo'];
    status = json['ISActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['Password'] = this.password;
    data['NAVDriverNo'] = this.nAVDriverNo;
    data['ISActive'] = this.status;
    return data;
  }
}
