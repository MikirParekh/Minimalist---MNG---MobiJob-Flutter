import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minimalist/core/api_const.dart';
import 'package:minimalist/core/c_text.dart';
import 'package:minimalist/model/resp_model.dart';
import 'package:minimalist/screen/job_list/model/job_model.dart';
import 'package:minimalist/screen/login/repo/login_repo.dart';
import 'package:minimalist/service/secure_storage_service.dart';
import 'package:minimalist/utils/util.dart';
import 'package:minimalist/widget/toast_notification.dart';

class JobRepository {
  Future<List<JobModel>> getJob(
      int status, String fromDate, String toDate) async {
    final SecureStorageService storageService = SecureStorageService();
    var driverNo = await storageService.readData(CText.driverNo);
    try {
      String? token = await storageService.readData('token');
      http.Response response = await http.get(
        Uri.parse(
            '${ApiConst.baseUrl}GetJobList?Status=${status == 3 ? "11" : status}&Driverno=$driverNo&fromdate=$fromDate&Todate=$toDate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["Completed"] == true) {
          final List result = data["Data"];
          var list = result.map((e) => JobModel.fromJson(e)).toList();
          return list;
        } else {
          return [];
        }
      } else {
        if (response.statusCode == 401) {
          notify("session Expired Please Login Again");
          return [];
        } else {
          return [];
        }
      }
    } on TimeoutException catch (_) {
      throw Exception("Time out");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<JobModel> getJobDetails(String jobNo) async {
    debugPrint(jobNo.toString());
    final SecureStorageService storageService = SecureStorageService();
    try {
      String? token = await storageService.readData('token');
      http.Response response = await http.get(
        Uri.parse('${ApiConst.baseUrl}GetJobDetails?no=$jobNo'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["Completed"] == true) {
          return JobModel.fromJson(data["Data"]);
        } else {
          return JobModel();
        }
      } else {
        if (response.statusCode == 401) {
          LoginRepository loginRepository = LoginRepository();
          String? username = await storageService.readData('username');
          String? password = await storageService.readData('password');
          final user =
              await loginRepository.login(username ?? '', password ?? '');
          if (user.completed == true) {
            return await getJobDetails(jobNo);
          } else {
            notify("session Expired Please Login Again");
            return JobModel();
          }
        } else {
          return JobModel();
        }
      }
    } on TimeoutException catch (_) {
      throw Exception("Connection Time out");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ResponseModel> jobDetailsStatusChange(
    String jonNo,
    String status,
    String customerSignature,
    String driverSignature,
    String customerLatLong,
    String driverLatLong,
    String remark,
    String pickupTime,
    int withSign,
    // String raStatus
  ) async {
    final SecureStorageService storageService = SecureStorageService();
    String? token = await storageService.readData('token');
    String driverno = await storageService.readData(CText.driverNo) ?? '';
    ResponseModel responseModel = ResponseModel();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> bodyData = {
      "JobNo": jonNo,
      "AppStatus": status,
      "Customer_Signature": customerSignature,
      "Driver_Signature": driverSignature,
      "Customer_latlong": customerLatLong,
      "Driver_No": driverno,
      "Remarks": remark,
      "PickUpTime": pickupTime,
      "WithSignture": withSign,
      // "RAStatus": raStatus
    };

    var d = jsonEncode(bodyData);

    showLog("jobDetailsupdate body data ------->  $d");

    try {
      http.Response response = await http
          .post(
            Uri.parse('${ApiConst.baseUrl}UpdateRAStatus'),
            headers: headers,
            body: jsonEncode(bodyData),
          )
          .timeout(const Duration(seconds: 30));
      var data = jsonDecode(response.body);

      showLog("jobDetails update body ------->  $data");

      if (response.statusCode == 200) {
        if (data['Completed'] == true) {
          responseModel.message = data['Message'] ?? '';
          responseModel.status = true;
        } else {
          responseModel.message = data['Message'] ?? '';
          responseModel.status = false;
        }
      } else {
        if (response.statusCode == 401) {
          LoginRepository loginRepository = LoginRepository();
          String? username = await storageService.readData('username');
          String? password = await storageService.readData('password');
          final user =
              await loginRepository.login(username ?? '', password ?? '');
          if (user.completed == true) {
            return await jobDetailsStatusChange(
                jonNo,
                status,
                customerSignature,
                driverSignature,
                customerLatLong,
                driverLatLong,
                remark,
                pickupTime,
                withSign
                // raStatus
                );
          } else {
            notify("session Expired Please Login Again");
            responseModel.message = 'Service is not working';
            responseModel.status = false;
          }
        } else {
          responseModel.message = 'Service is not working';
          responseModel.status = false;
        }
      }
    } on TimeoutException catch (_) {
      responseModel.message = 'Connection Time Out';
      responseModel.status = false;
    } catch (e) {
      responseModel.message = e.toString();
      responseModel.status = false;
    }
    return responseModel;
  }

  Future<ResponseModel> jobStart(String jonNo, String drivelatlong) async {
    final SecureStorageService storageService = SecureStorageService();
    String? token = await storageService.readData('token');
    String driverno = await storageService.readData(CText.driverNo) ?? '';
    ResponseModel responseModel = ResponseModel();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final Map<String, dynamic> bodyData = {
      "Driver_latlong": drivelatlong,
      "JobNo": jonNo,
      "Driver_No": driverno,
    };

    var d = jsonEncode(bodyData);

    try {
      http.Response response = await http
          .post(
            Uri.parse('${ApiConst.baseUrl}Startbutton'),
            headers: headers,
            body: jsonEncode(bodyData),
          )
          .timeout(const Duration(seconds: 30));
      debugPrint(response.statusCode.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        responseModel.status = true;
      } else {
        if (response.statusCode == 401) {
          responseModel.message = 'Session Expired Please Login Again.';
        } else {
          responseModel.message = 'Service is not working';
        }
        responseModel.status = false;
      }
    } on TimeoutException catch (_) {
      responseModel.message = 'Connection Time Out';
      responseModel.status = false;
    } catch (e) {
      responseModel.message = e.toString();
      responseModel.status = false;
    }
    return responseModel;
  }

  Future<ResponseModel> jobUpdateTime(String jonNo, String pickupTime) async {
    final SecureStorageService storageService = SecureStorageService();
    String? token = await storageService.readData('token');
    String driverno = await storageService.readData(CText.driverNo) ?? '';
    ResponseModel responseModel = ResponseModel();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      http.Response response = await http
          .post(
            Uri.parse(
                '${ApiConst.baseUrl}updatepickuptime?time=$pickupTime&jobno=$jonNo'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 30));
      debugPrint(response.statusCode.toString());
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        responseModel.status = true;
      } else {
        if (response.statusCode == 401) {
          responseModel.message = 'Session Expired Please Login Again.';
        } else {
          responseModel.message = 'Service is not working';
        }
        responseModel.status = false;
      }
    } on TimeoutException catch (_) {
      responseModel.message = 'Connection Time Out';
      responseModel.status = false;
    } catch (e) {
      responseModel.message = e.toString();
      responseModel.status = false;
    }
    return responseModel;
  }
}
