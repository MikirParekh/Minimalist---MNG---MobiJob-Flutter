import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist/core/loader.dart';
import 'package:minimalist/screen/dashboard/bloc/count_bloc.dart';
import 'package:minimalist/screen/dashboard/view/home_page.dart';
import 'package:minimalist/screen/job_details/bloc/job_details_submit/job_details_submit_bloc.dart';
import 'package:minimalist/screen/job_list/repo/job_repo.dart';
import 'package:minimalist/screen/logout/logout.dart';
import 'package:minimalist/widget/toast_notification.dart';
import 'package:signature/signature.dart';
import 'package:toastification/toastification.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad(
      {super.key,
      required this.jonNo,
      required this.status,
      required this.remark,
      required this.isPending,
      required this.pickupTime});

  final String? jonNo;
  final String? status;
  final String? remark;
  final bool? isPending;
  final String pickupTime;

  @override
  _SignaturePad createState() => _SignaturePad();

  static const path = '/signaturePad';
}

class _SignaturePad extends State<SignaturePad> {
  SignatureController customerController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  SignatureController driverController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  var customerSignature;
  var driverSignature;

  JobDetailsSubmitBloc jobDetailsSubmitBloc = JobDetailsSubmitBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => jobDetailsSubmitBloc,
      child: BlocListener<JobDetailsSubmitBloc, JobDetailsSubmitState>(
        listener: (context, state) {
          if (state is GetJobDetailSubmitLoading) {
            LoaderUtils(context).startLoading();
          }
          if (state is GetJobDetailSubmitLoaded) {
            LoaderUtils(context).stopLoading();
            notify(state.responseModel.message ?? '',
                toastificationType: ToastificationType.success);
            context.read<CountBloc>().add(FetchCount());
            context.go(Dashboard.path);
          }
          if (state is GetJobDetailSubmitError) {
            LoaderUtils(context).stopLoading();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue[900],
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Signature pad',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.grey[300],
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Signatures',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          customerController.clear();
                        },
                        child: Text(
                          'Clear',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Signature(
                    controller: customerController,
                    height: 150,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Driver Signatures',
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          driverController.clear();
                        },
                        child: Text(
                          'Clear',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Signature(
                    controller: driverController,
                    height: 150,
                    backgroundColor: Colors.white,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: MaterialButton(
                      onPressed: () async {
                        ///////////////////////////////////////////
                        try {
                          var activeStatus =
                              await JobRepository().isActiveStatus();
                          if (activeStatus == true) {
                            LoaderUtils(context).startLoading();
                            var result = await getCurrentLocation();
                            if (result.status == true) {
                              LoaderUtils(context).stopLoading();
                              customerSignature =
                                  await customerController.toPngBytes(
                                      /* width: MediaQuery.of(context).size.width.toInt(),height: 150*/
                                      );
                              driverSignature = await driverController.toPngBytes(
                                  /*width: MediaQuery.of(context).size.width.toInt(),height: 150*/
                                  );
                              if (customerSignature == null) {
                                notify("Customer signature is missing");
                                return;
                              }
                              if (driverSignature == null) {
                                notify("Driver signature is missing");
                                return;
                              }
                              jobDetailsSubmitBloc.add(SubmitJobDetailsEvent(
                                jonNo: widget.jonNo ?? '',
                                status: widget.status ?? '',
                                customerSignature:
                                    base64Encode(customerSignature),
                                driverSignature: base64Encode(driverSignature),
                                customerLatLong:
                                    "${result.position!.latitude},${result.position!.longitude}",
                                driverLatLong:
                                    "${result.position!.latitude},${result.position!.longitude}",
                                remark: widget.remark ?? "",
                                pickupTime: widget.pickupTime,
                                withSignature: 1,
                                // raStatus: widget.status.toString()
                              ));
                            } else {
                              LoaderUtils(context).stopLoading();
                              notify(result.msg.toString());
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    LogoutDialogBox(isPermitted: false),
                              );
                            }
                          } else {
                            LoaderUtils(context).stopLoading();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) =>
                                  LogoutDialogBox(isPermitted: false),
                            );
                          }
                        } catch (e) {
                          LoaderUtils(context).stopLoading();
                          notify(e.toString());
                          debugPrint(e.toString());
                        }
                      },
                      height: 50,
                      minWidth: 100,
                      color: Colors.lightBlue[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                widget.isPending == false
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: MaterialButton(
                            onPressed: () async {
                              var activeStatus =
                                  await JobRepository().isActiveStatus();
                              if (activeStatus == true) {
                                var result = await getCurrentLocation();
                                if (result.status == true) {
                                  jobDetailsSubmitBloc
                                      .add(SubmitJobDetailsEvent(
                                    jonNo: widget.jonNo ?? '',
                                    status: widget.status ?? '',
                                    // status: "11",
                                    customerSignature: "",
                                    driverSignature: "",
                                    customerLatLong:
                                        "${result.position!.latitude},${result.position!.longitude}",
                                    driverLatLong: "",
                                    remark: widget.remark ?? "",
                                    pickupTime: widget.pickupTime,
                                    withSignature: widget.status == '7' ? 0 : 1,
                                    // raStatus: widget.status.toString()
                                  ));
                                } else {
                                  LoaderUtils(context).stopLoading();
                                  notify(result.msg.toString());
                                }
                              } else {
                                LoaderUtils(context).stopLoading();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) =>
                                      LogoutDialogBox(isPermitted: false),
                                );
                              }
                            },
                            height: 50,
                            minWidth: 100,
                            color: Colors.red[500],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Submit without Sign',
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<PermissionModel> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return PermissionModel(
        status: false, msg: "Location services are disabled.");
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return PermissionModel(
          status: false, msg: "Location permissions are denied.");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return PermissionModel(
        status: false,
        msg:
            "Location permissions are permanently denied, we cannot submit request.\nOpen setting to Enable Permission");
  }
  try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return PermissionModel(
      position: position,
      status: true,
    );
  } catch (e) {
    return PermissionModel(
      status: false,
      msg: "Error retrieving location: ${e.toString()}",
    );
  }
}

class PermissionModel {
  String? msg;
  bool? status;
  Position? position;

  PermissionModel({this.msg, this.status, this.position});
}
