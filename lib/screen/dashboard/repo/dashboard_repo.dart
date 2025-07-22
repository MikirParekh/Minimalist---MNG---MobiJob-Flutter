import 'dart:async';
import 'dart:convert';
import 'package:minimalist/core/api_const.dart';
import 'package:minimalist/core/c_text.dart';
import 'package:minimalist/screen/dashboard/model/count_model.dart';
import 'package:http/http.dart' as http;
import 'package:minimalist/screen/login/repo/login_repo.dart';
import 'package:minimalist/service/secure_storage_service.dart';
import 'package:minimalist/widget/toast_notification.dart';

class DashboardRepository{
  Future<CountModel> getCount() async {
    final SecureStorageService storageService = SecureStorageService();
    var driverNo = await storageService.readData(CText.driverNo);
    try {
      String? token = await storageService.readData('token');

      http.Response response = await http.get(
        Uri.parse('${ApiConst.baseUrl}GetJobCounts?DriverNo=$driverNo'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return CountModel.fromJson(data);
      } else {
        if(response.statusCode == 401){
          notify(response.statusCode.toString());
          LoginRepository loginRepository = LoginRepository();
          String? username = await storageService.readData('username');
          String? password = await storageService.readData('password');
          final user = await loginRepository.login(username ?? '',password ?? '');
          if(user.completed == true){
            await getCount();
          }else {
            notify("session Expired Please Login Again");
            return CountModel();
          }
        }
        throw Exception('Service is not working.');
      }
    }on TimeoutException catch (_){
      throw Exception("Time out");
    }catch(e){
      throw Exception(e.toString());
    }
  }
}

/*
class DashboardRepository {
  final SecureStorageService _storageService = SecureStorageService();
  final LoginRepository _loginRepository = LoginRepository();

  Future<CountModel> getCount() async {
    try {
      // Get required data from secure storage
      var driverNo = await _storageService.readData(CText.driverNo);
      String? token = await _storageService.readData('token');

      // Make the HTTP request
      http.Response response = await _makeRequest(driverNo ?? "0", token);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return CountModel.fromJson(data);
      } else if (response.statusCode == 401) {
        // Handle token expiration
        bool tokenRefreshed = await _refreshToken();
        if (tokenRefreshed) {
          return await getCount(); // Retry after refreshing the token
        } else {
          notify("Session expired. Please log in again.");
          return CountModel();
        }
      } else {
        throw Exception('Service returned status code: ${response.statusCode}');
      }
    }on SocketException {
      notify("No internet connection. Please check your network and try again.");
      throw Exception("No internet connection.");
    } on TimeoutException {
      throw Exception("Request timed out. Please try again later.");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<http.Response> _makeRequest(String driverNo, String? token) {
    return http.get(
      Uri.parse('${ApiConst.baseUrl}GetJobCounts?DriverNo=$driverNo'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 30));
  }

  Future<bool> _refreshToken() async {
    try {
      String? username = await _storageService.readData('username');
      String? password = await _storageService.readData('password');
      final user = await _loginRepository.login(username ?? '', password ?? '');
      return user.completed == true;
    } catch (e) {
      notify("Failed to refresh token. Please log in again.");
      return false;
    }
  }
}*/
