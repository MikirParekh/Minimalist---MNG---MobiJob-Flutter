class LoginRespModel {
  Data? data;
  String? message;
  bool? completed;
  String? token;

  LoginRespModel({this.data, this.message, this.completed});

  LoginRespModel.fromJson(Map<String, dynamic> json) {
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
    message = json['Message'];
    completed = json['Completed'];
    token = json['Token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    data['Message'] = message;
    data['Completed'] = completed;
    data['Token'] = token;
    return data;
  }
}

class Data {
  String? username;
  String? password;
  String? userId;
  String? driverNo;

  Data({this.username, this.password});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    username = json['UserName'];
    password = json['Password'];
    driverNo = json['NAVDriverNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['UserName'] = username;
    data['Password'] = password;
    data['NAVDriverNo'] = driverNo;
    return data;
  }
}
