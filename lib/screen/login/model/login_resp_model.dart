class LoginRespModel {
  Data? data;
  String? message;
  bool? completed;
  String? token;
  // int? hasPermission;

  LoginRespModel({this.data, this.message, this.completed});

  LoginRespModel.fromJson(Map<String, dynamic> json) {
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
    message = json['Message'];
    completed = json['Completed'];
    token = json['Token'] ?? '';
    // hasPermission = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    data['Message'] = message;
    data['Completed'] = completed;
    data['Token'] = token;
    // data['Status'] = hasPermission;
    return data;
  }
}

class Data {
  String? username;
  String? password;
  String? userId;
  String? driverNo;
  int? hasPermission;

  Data({this.username, this.password});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    username = json['UserName'];
    password = json['Password'];
    driverNo = json['NAVDriverNo'];
    hasPermission = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['UserName'] = username;
    data['Password'] = password;
    data['NAVDriverNo'] = driverNo;
    data['Status'] = hasPermission;
    return data;
  }
}
