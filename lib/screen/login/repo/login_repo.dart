import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:minimalist/core/api_const.dart';
import 'package:minimalist/core/loader.dart';
import 'package:minimalist/screen/login/model/login_resp_model.dart';
import 'package:minimalist/service/secure_storage_service.dart';
import 'package:minimalist/widget/toast_notification.dart';
import 'package:toastification/toastification.dart';

class LoginRepository{
  Future<LoginRespModel> login(String username,String password) async {
    SecureStorageService storageService = SecureStorageService();
    try {
      http.Response response = await http.get(
        Uri.parse('${ApiConst.baseUrl}GetUserDetail?username=$username&password=$password'),
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var res = LoginRespModel.fromJson(data);
        if(res.data != null) {
          await storageService.writeData("token", res.token ?? '');
          await storageService.writeData("username", username);
          await storageService.writeData("password", password);
          await storageService.writeData("UserId", res.data!.userId ?? '');
          return res;
        }else{
          return res;
        }
      } else {
        throw Exception('Service is not working.');
      }
    }on TimeoutException catch (_){
      throw Exception("Time out");
    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword(BuildContext context,String cPass,String nPass) async {
    LoaderUtils(context).startLoading();
    SecureStorageService storageService = SecureStorageService();
    var userid = await storageService.readData("UserId");
    try {
      String? token = await storageService.readData('token');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      };

      http.Response response = await http.post(
        headers: headers,
        Uri.parse('${ApiConst.baseUrl}ChangePassword?userid=$userid&newPassword=$nPass'),
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if(data["Completed"] == true){
          notify(data["Message"],toastificationType: ToastificationType.success);
          await storageService.clearStorage();
          GoRouter.of(context).go('/');
        }else{
          notify(data["Message"]);
        }
      } else {
        if(response.statusCode == 401){
          notify("Session is Expired Please Login Again.");
        }else{
          notify(response.statusCode.toString());
        }
      }
    }on TimeoutException catch (_){
      notify("Time out");
      throw Exception("Time out");
    }catch(e){
      notify("$e");
      throw Exception(e.toString());
    }finally{
      LoaderUtils(context).stopLoading();
    }
  }
}