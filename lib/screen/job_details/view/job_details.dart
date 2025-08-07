// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:minimalist/core/loader.dart';
// import 'package:minimalist/screen/job_details/bloc/get_job_details_bloc/get_job_detail_bloc.dart';
// import 'package:minimalist/screen/job_details/view/signature_pad.dart';
// import 'package:minimalist/screen/job_list/model/job_model.dart';
// import 'package:minimalist/screen/job_list/repo/job_repo.dart';
// import 'package:minimalist/screen/map/google_map_widget.dart';
// import 'package:minimalist/utils/util.dart';
// import 'package:minimalist/widget/toast_notification.dart';
// import 'package:toastification/toastification.dart';
//
// class JobDetails extends StatefulWidget {
//   const JobDetails({super.key, required this.jonNo, required this.listStatus});
//
//   final String? jonNo;
//   final String? listStatus;
//
//   @override
//   _JobDetails createState() => _JobDetails();
//
//
//
//   static const path = '/JobDetails';
// }
//
// class _JobDetails extends State<JobDetails> {
//   GetJobDetailBloc getJobDetailBloc = GetJobDetailBloc();
//   TextEditingController remarkTextbox = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     getJobDetailBloc.add(FetchJobDetailEvent(jobNo: widget.jonNo ?? ''));
//     debugPrint(widget.jonNo);
//   }
//
//   final List<Map<String, dynamic>> statuses = [
//     {'label': 'JOB COMPLETED', 'value': 7, 'isChecked': false},
//     {'label': 'MISSED PASSENGER', 'value': 10, 'isChecked': false},
//     {'label': 'JOB CANCELLED BY', 'value': 4, 'isChecked': false},
//     {'label': 'NO SHOW', 'value': 8, 'isChecked': false},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => getJobDetailBloc,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.lightBlue[900],
//           iconTheme: const IconThemeData(color: Colors.white),
//           title: Text(
//             //'Job Details',
//             widget.listStatus == "0" ? "Today's Jobs Details" : widget.listStatus == "1" ? "Tomorrow's Jobs Details" : "Today's Completed Jobs Details",
//             style: GoogleFonts.quicksand(color: Colors.white),
//           ),
//         ),
//         backgroundColor: Colors.grey[300],
//         body: SafeArea(
//           child: Center(
//             child: BlocConsumer<GetJobDetailBloc, GetJobDetailState>(
//               listener: (context, state) {
//                 if (state is GetJobDetailError) {
//                   notify(state.error);
//                 }
//               },
//               builder: (context, state) {
//                 if (state is GetJobDetailLoading) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 if (state is GetJobDetailLoaded) {
//                   var job = state.job;
//                   if (job.pickUpDate != null) {
//                     return  widget.listStatus == '2'
//                         ? showOnlyDetails(job)
//                         : Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//                           margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16)),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       job.customerName ?? '',
//                                       style: GoogleFonts.quicksand(
//                                           fontWeight: FontWeight.w900),
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       //formatStrDate(job.pickUpDate ?? '0001-01-01') ?? '',
//                                       formatStrDate(job.pickUpDate ?? '') ?? "",
//                                       style: GoogleFonts.quicksand(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               IconButton(onPressed: (){
//                                 showImagePopup(context,job.logo);
//                               }, icon: Icon(Icons.link_rounded))
//                             ],
//                           ),
//                         ),
//                         Container(
//                           color: Colors.blueAccent,
//                           width: double.maxFinite,
//                           height: 2,
//                           margin: const EdgeInsets.fromLTRB(26, 0, 26, 0),
//                         ),
//                         Expanded(
//                           child: Container(
//                             padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//                             margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(16)),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Pickup Time',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               convertTo12HourFormat(job.pickUpTime ?? ''),
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Container(
//                                           padding: const EdgeInsets.all(8),
//                                           child: MaterialButton(
//                                             onPressed: () async {
//                                               LoaderUtils(context).startLoading();
//                                               var result = await getCurrentLocation();
//                                               if(result.status == true){
//                                                 var response = await JobRepository().jobStart(
//                                                   job.jobNo ?? '',
//                                                   "${result.position!.latitude},${result.position!.longitude}",
//                                                 );
//                                                 if(response.status == true){
//                                                   notify("Start",toastificationType: ToastificationType.success);
//                                                 }else{
//                                                   notify(response.message.toString());
//                                                 }
//                                               }else{
//                                                 notify(result.msg.toString());
//                                               }
//                                               LoaderUtils(context).stopLoading();
//                                             },
//                                             height: 50,
//                                             color: Colors.lightBlue[900],
//                                             shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(10)),
//                                             child: Text(
//                                               'Start',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   /*Padding(
//                                     padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                           'Sales ID',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           job.salesID ?? '',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),*/
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         /*Column(
//                                           children: [
//                                             Text(
//                                               'Issued By',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               job.issuedBy ?? '',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),*/
//                                         Column(
//                                           children: [
//                                             Text(
//                                               'Service Type',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               job.serviceType.toString(),
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Transfer Type',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               job.transferType.toString(),
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//
//                                         /*Column(
//                                           children: [
//                                             Text(
//                                               'Car Reg. No.',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               job.carRegNo ?? '',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),*/
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                     const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                           'Car Type',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           job.carType ?? '',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Customer/Booking Agent',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           job.customerBookingAgent ?? '',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Passenger Name',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           job.passengerName ?? '',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Reference',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               job.reference ?? '',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Tel no.',
//                                         style: GoogleFonts.quicksand(
//                                           fontSize: 15,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         job.telNo ?? '',
//                                         style: GoogleFonts.quicksand(
//                                           fontSize: 15,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Flight No.',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               job.flightNo ?? '',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.end,
//                                           children: [
//                                             Text(
//                                               'ETA/ETD',
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             Text(
//                                               /*formatStrDate(job.eTAETD ??
//                                                       '0001-01-01') ??
//                                                   '',*/
//                                               formatStrDate(job.eTAETD ?? '') ?? "",
//                                               style: GoogleFonts.quicksand(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Pickup Address',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           job.pickupAddress ?? '',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Drop off Address',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           job.dropoffAddress ?? '',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'END TIME',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           //formatStrDate(job.endTime ?? '') ?? '',
//                                           formatStrDate(job.endTime ?? '') ?? "",
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: List.generate(
//                                           statuses.length,
//                                               (index) =>
//                                               buildCheckbox(index)),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Remark',
//                                           style: GoogleFonts.quicksand(
//                                             fontSize: 15,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         TextFormField(
//                                           controller: remarkTextbox,
//                                           decoration: InputDecoration(
//                                             hintText: "Remark"
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                                 padding: const EdgeInsets.all(8),
//                                 width: double.maxFinite,
//                                 child: MaterialButton(
//                                   onPressed: () {
//                                     int selectedIndex = statuses.indexWhere(
//                                         (status) => status['isChecked']);
//                                     if (selectedIndex != -1) {
//                                       context.push(SignaturePad.path, extra: {
//                                         "jobNo": widget.jonNo,
//                                         "status": statuses[selectedIndex]['value'].toString(),
//                                         "remark": remarkTextbox.text.toString()
//                                       });
//                                     } else {
//                                       notify("Select One of the Checkbox");
//                                     }
//                                   },
//                                   height: 50,
//                                   minWidth: 360,
//                                   color: Colors.lightBlue[900],
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Text(
//                                     'Submit',
//                                     style: GoogleFonts.quicksand(
//                                       fontSize: 15,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                       ],
//                     );
//                   } else {
//                     return const Center(child: Text("No data"));
//                     //return showGoogleMap();
//                   }
//                 }
//                 return const SizedBox();
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildCheckbox(int index) {
//     return Row(
//       children: [
//         Checkbox(
//           value: statuses[index]['isChecked'],
//           activeColor: Colors.lightBlue[900],
//           onChanged: (bool? value) {
//             setState(() {
//               // Set all checkboxes to false except the current one
//               for (int i = 0; i < statuses.length; i++) {
//                 statuses[i]['isChecked'] = i == index ? value! : false;
//               }
//             });
//           },
//         ),
//         Text(
//           statuses[index]['label'], // Access the label from the map
//           style: GoogleFonts.quicksand(
//             fontSize: 15,
//             color: Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget showOnlyDetails(JobModel job){
//     String formattedEndTimeDate ='';
//     if(job.endTime != null) {
//       DateTime parsedDate = DateTime.parse(job.endTime ?? "");
//       formattedEndTimeDate = DateFormat('dd MMM yyyy hh:mm a').format(
//           parsedDate);
//     }
//     return ListView(
//       //crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//           margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16)),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       job.customerName ?? '',
//                       style: GoogleFonts.quicksand(
//                           fontWeight: FontWeight.w900),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       //formatStrDate(job.pickUpDate ?? '0001-01-01') ?? '',
//                       formatStrDate(job.pickUpDate ?? '') ?? "",
//                       style: GoogleFonts.quicksand(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(onPressed: (){
//                 showImagePopup(context,job.logo);
//               }, icon: Icon(Icons.link_rounded))
//             ],
//           ),
//         ),
//         Container(
//           color: Colors.blueAccent,
//           width: double.maxFinite,
//           height: 2,
//           margin: const EdgeInsets.fromLTRB(26, 0, 26, 0),
//         ),
//         Container(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//           margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                 child: Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//                   children: [
//                     /*Column(
//                       children: [
//                         Text(
//                           'Pick Up Date',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           //'${formatStrDate(job.pickUpDate ?? '')}',
//                           formatStrDate(job.App_startDate ?? '') ?? "",
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),*/
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Pickup Time',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           convertTo12HourFormat(job.pickUpTime ?? ''),
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               /*Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Sales ID',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       job.salesID ?? '',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),*/
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                 child: Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//                   children: [
//                     /*Column(
//                       children: [
//                         Text(
//                           'Issued By',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           job.issuedBy ?? '',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),*/
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Service Type',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           job.serviceType.toString(),
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                 child: Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Transfer Type',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           job.transferType.toString(),
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     /*Column(
//                       children: [
//                         Text(
//                           'Car Reg. No.',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           job.carRegNo ?? '',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),*/
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Car Type',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       job.carType ?? '',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Customer/Booking Agent',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       job.customerBookingAgent ?? '',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               /*Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Driver Name',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       job.driverName ?? '',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),*/
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Passenger Name',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       job.passengerName ?? '',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Reference',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           job.reference ?? '',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Tel no.',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           job.telNo ?? '',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Row(
//                   mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Flight No.',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           job.flightNo ?? '',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           'ETA/ETD',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           formatStrDate(job.eTAETD ??
//                               '0001-01-01') ??
//                               '',
//                           style: GoogleFonts.quicksand(
//                             fontSize: 15,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Pickup Address',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       job.pickupAddress ?? '',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Drop off Address',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       job.dropoffAddress ?? '',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'END TIME',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       formattedEndTimeDate,
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.fromLTRB(0, 8, 0, 8),
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Remarks/Special Instructions',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       job.Remarks ?? '',
//                       style: GoogleFonts.quicksand(
//                         fontSize: 15,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               widget.listStatus == "2"
//                   ? const SizedBox()
//                   : Padding(
//                 padding: const EdgeInsets.fromLTRB(
//                     0, 0, 0, 8),
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: List.generate(
//                       statuses.length,
//                           (index) =>
//                           buildCheckbox(index)),
//                 ),
//               )
//             ],
//           ),
//         ),
//         job.customerSignature != null ?
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Customer Signature",
//                 style: GoogleFonts.quicksand(
//                     fontWeight: FontWeight.w900),
//               ),
//               Image.memory(
//                 fit: BoxFit.contain,
//                 width: MediaQuery.of(context).size.width,
//                 base64Decode(
//                   job.customerSignature,
//                 ),
//               ),
//             ],
//           ),
//         ) : const SizedBox(),
//
//         job.Driver_latlong!.isEmpty ? SizedBox() : Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Start Point",
//                 style: GoogleFonts.quicksand(
//                     fontWeight: FontWeight.w900),
//               ),
//               SizedBox(
//                   height: 300,width: double.maxFinite,
//                   child: MapSample(title: "Start Point",latLngString: job.Driver_latlong ?? '',)),
//             ],
//           ),
//         ),
//
//         job.Customer_latlong!.isEmpty ? SizedBox() : Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "End Point",
//                 style: GoogleFonts.quicksand(
//                     fontWeight: FontWeight.w900),
//               ),
//               SizedBox(
//                   height: 300,width: double.maxFinite,
//                   child: MapSample(title: "End Point",latLngString: job.Customer_latlong ?? '',)),
//             ],
//           ),
//         ),
//
//         job.driverSignature != null ? Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Driver Signature",
//                 style: GoogleFonts.quicksand(
//                     fontWeight: FontWeight.w900),
//               ),
//               Image.memory(
//                   width: MediaQuery.of(context).size.width,
//                   fit: BoxFit.contain,
//                   base64Decode(job.driverSignature)),
//
//             ],
//           ),
//         ) : const SizedBox(),
//
//       ],
//     );
//   }
//
//   void showImagePopup(BuildContext context,var base64) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black54, // Background overlay color
//       barrierDismissible: true, // Allow dismiss by tapping outside
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent, // Transparent background
//           insetPadding: EdgeInsets.all(10), // Padding around the popup
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // Adjust size to fit the content
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10), // Rounded corners
//                 /*child: Image.asset(
//                   "assets/images/cnplogo.png",
//                   fit: BoxFit.cover,
//                 ),*/
//                 child: base64 == null || base64.toString().isEmpty ? SizedBox() : Image.memory(
//                     width: MediaQuery.of(context).size.width,
//                     fit: BoxFit.contain,
//                     base64Decode(base64)),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:minimalist/core/loader.dart';
import 'package:minimalist/screen/dashboard/bloc/count_bloc.dart';
import 'package:minimalist/screen/job_details/bloc/get_job_details_bloc/get_job_detail_bloc.dart';
import 'package:minimalist/screen/job_details/view/signature_pad.dart';
import 'package:minimalist/screen/job_list/model/job_model.dart';
import 'package:minimalist/screen/job_list/repo/job_repo.dart';
import 'package:minimalist/screen/map/google_map_widget.dart';
import 'package:minimalist/utils/util.dart';
import 'package:minimalist/widget/toast_notification.dart';
import 'package:toastification/toastification.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key, required this.jonNo, required this.listStatus});

  final String? jonNo;
  final String? listStatus;

  @override
  _JobDetails createState() => _JobDetails();

  static const path = '/JobDetails';
}

class _JobDetails extends State<JobDetails> {
  GetJobDetailBloc getJobDetailBloc = GetJobDetailBloc();
  TextEditingController remarkTextbox = TextEditingController();

  TimeOfDay? _selectedTime;
  DateTime? fullDateTime;
  bool callListApi = false;

  @override
  void initState() {
    super.initState();
    context.read<CountBloc>().add(FetchCount());
    getJobDetailBloc.add(FetchJobDetailEvent(jobNo: widget.jonNo ?? ''));
  }

  final List<Map<String, dynamic>> statuses = [
    {'label': 'JOB COMPLETED', 'value': 7, 'isChecked': false},
    {
      'label': 'MISSED PASSENGER',
      'value': 12, // VALUE UPDATE FROM 10 TO 12
      'isChecked': false
    },
    {'label': 'JOB CANCELLED BY', 'value': 4, 'isChecked': false},
    {'label': 'NO SHOW', 'value': 8, 'isChecked': false},
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.pop(callListApi);
        }
      },
      child: BlocProvider(
        create: (context) => getJobDetailBloc,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue[900],
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              //'Job Details',
              widget.listStatus == "0"
                  ? "Today's Jobs Details"
                  : widget.listStatus == "1"
                      ? "Tomorrow's Jobs Details"
                      : widget.listStatus == "2"
                          ? "Today's Completed Jobs Details"
                          : "Pending Sign Job",
              style: GoogleFonts.quicksand(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.grey[300],
          body: SafeArea(
            child: Center(
              child: BlocConsumer<GetJobDetailBloc, GetJobDetailState>(
                listener: (context, state) {
                  if (state is GetJobDetailError) {
                    notify(state.error);
                  }
                },
                builder: (context, state) {
                  if (state is GetJobDetailLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is GetJobDetailLoaded) {
                    var job = state.job;
                    if (job.pickUpDate != null) {
                      bool isPassed =
                          isAppStartTimeIsPassed(job.App_startDate ?? '') ??
                              false;
                      return widget.listStatus == '2'
                          ? showOnlyDetails(job)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              job.customerName ?? '',
                                              style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              formatStrDate(
                                                      job.pickUpDate ?? '') ??
                                                  "",
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showImagePopup(context, job.logo);
                                          },
                                          icon: Icon(Icons.link_rounded))
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.blueAccent,
                                  width: double.maxFinite,
                                  height: 2,
                                  margin:
                                      const EdgeInsets.fromLTRB(26, 0, 26, 0),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 12, 16, 12),
                                    margin:
                                        const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Pickup Time',
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        (widget.listStatus ==
                                                                        "0" ||
                                                                    widget.listStatus ==
                                                                        "1") &&
                                                                !isPassed
                                                            ? IconButton(
                                                                onPressed: () {
                                                                  _selectTime(
                                                                      context);
                                                                },
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blue,
                                                                ))
                                                            : SizedBox()
                                                      ],
                                                    ),
                                                    Text(
                                                      _selectedTime != null
                                                          ? formatTimeOfDay(
                                                              _selectedTime!)
                                                          : formatStrTime(
                                                                  job.pickUpTime ??
                                                                      '') ??
                                                              '',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                (widget.listStatus == "0" ||
                                                            widget.listStatus ==
                                                                "1") &&
                                                        !isPassed
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: MaterialButton(
                                                          onPressed:
                                                              fullDateTime ==
                                                                      null
                                                                  ? null
                                                                  : () async {
                                                                      LoaderUtils(
                                                                              context)
                                                                          .startLoading();
                                                                      var response =
                                                                          await JobRepository()
                                                                              .jobUpdateTime(
                                                                        job.jobNo ??
                                                                            '',
                                                                        "${fullDateTime ?? " "}",
                                                                      );
                                                                      if (response
                                                                              .status ==
                                                                          true) {
                                                                        notify(
                                                                            "Pickup Time Updated",
                                                                            toastificationType:
                                                                                ToastificationType.success);
                                                                        getJobDetailBloc.add(FetchJobDetailEvent(
                                                                            jobNo:
                                                                                widget.jonNo ?? ''));
                                                                        callListApi =
                                                                            true;
                                                                      } else {
                                                                        notify(response
                                                                            .message
                                                                            .toString());
                                                                      }
                                                                      LoaderUtils(
                                                                              context)
                                                                          .stopLoading();
                                                                    },
                                                          height: 50,
                                                          color: Colors
                                                              .lightBlue[900],
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          disabledColor:
                                                              Colors.grey,
                                                          child: Text(
                                                            'Update Time',
                                                            style: GoogleFonts
                                                                .quicksand(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start, // ALIGNMENT ADDED TO LEFT
                                                  children: [
                                                    Text(
                                                      'Service Type',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      job.serviceType
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Transfer Type',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      job.transferType
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Car Type',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      job.carType.toString() ??
                                                          '',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Customer/Booking Agent',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  job.customerBookingAgent ??
                                                      '',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Passenger Name',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  job.passengerName ?? '',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Reference',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      job.reference ?? '',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tel no.',
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                job.telNo ?? '',
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Flight No.',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      job.flightNo ?? '',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'ETA/ETD',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      //convertTo12HourFormat(job.eTAETD ?? ''),
                                                      formatStrTime(
                                                              job.eTAETD ??
                                                                  '') ??
                                                          "",
                                                      style:
                                                          GoogleFonts.quicksand(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Pickup Address',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  job.pickupAddress ?? '',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Drop off Address',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  job.dropoffAddress ?? '',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'END TIME',
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  //formatStrDate(job.endTime ?? '') ?? '',
                                                  formatStrTime(
                                                          job.endTime ?? '') ??
                                                      "",
                                                  style: GoogleFonts.quicksand(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (widget.listStatus == "0") ...[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: List.generate(
                                                    statuses.length,
                                                    (index) => buildCheckbox(
                                                        index, true, 0)),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Remark',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: remarkTextbox,
                                                    decoration: InputDecoration(
                                                        hintText: "Remark"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                widget.listStatus == "0" && !isPassed
                                    ? Container(
                                        padding: const EdgeInsets.all(8),
                                        child: MaterialButton(
                                          onPressed: () async {
                                            context
                                                .read<CountBloc>()
                                                .add(FetchCount());
                                            LoaderUtils(context).startLoading();
                                            var result =
                                                await getCurrentLocation();
                                            if (result.status == true) {
                                              var response =
                                                  await JobRepository()
                                                      .jobStart(
                                                job.jobNo ?? '',
                                                "${result.position!.latitude},${result.position!.longitude}",
                                              );
                                              if (response.status == true) {
                                                notify("Start",
                                                    toastificationType:
                                                        ToastificationType
                                                            .success);
                                                getJobDetailBloc.add(
                                                    FetchJobDetailEvent(
                                                        jobNo: widget.jonNo ??
                                                            ''));
                                              } else {
                                                notify(response.message
                                                    .toString());
                                              }
                                            } else {
                                              notify(result.msg.toString());
                                            }
                                            LoaderUtils(context).stopLoading();
                                          },
                                          height: 50,
                                          minWidth: 360,
                                          color: Colors.lightBlue[900],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            'Start Job',
                                            style: GoogleFonts.quicksand(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : widget.listStatus == "0" ||
                                            widget.listStatus == "3"
                                        ? Container(
                                            padding: const EdgeInsets.all(8),
                                            width: double.maxFinite,
                                            child: MaterialButton(
                                              onPressed: () {
                                                context
                                                    .read<CountBloc>()
                                                    .add(FetchCount());
                                                int selectedIndex = statuses
                                                    .indexWhere((status) =>
                                                        status['isChecked']);
                                                if (widget.listStatus == "3"
                                                    ? true
                                                    : selectedIndex != -1) {
                                                  context.push(
                                                      SignaturePad.path,
                                                      extra: {
                                                        "jobNo": widget.jonNo,
                                                        "status": widget
                                                                    .listStatus ==
                                                                "3"
                                                            ? "7"
                                                            : statuses[selectedIndex]
                                                                    ['value']
                                                                .toString(),
                                                        "remark": remarkTextbox
                                                            .text
                                                            .toString(),
                                                        "isPending":
                                                            widget.listStatus ==
                                                                "3",
                                                        "pickTime":
                                                            "${fullDateTime ?? " "}"
                                                      });
                                                } else {
                                                  notify(
                                                      "Select One of the Checkbox");
                                                }
                                              },
                                              height: 50,
                                              minWidth: 360,
                                              color: Colors.lightBlue[900],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                'Submit',
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox()
                              ],
                            );
                    } else {
                      return const Center(child: Text("No data"));
                      //return showGoogleMap();
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCheckbox(int index, bool isEditable, num appStatus) {
    for (var v in statuses) {
      v['value'] == appStatus ? v["isChecked"] = true : false;
    }
    return Row(
      children: [
        Checkbox(
          value: statuses[index]['isChecked'],
          activeColor: Colors.lightBlue[900],
          onChanged: (bool? value) {
            if (isEditable) {
              setState(() {
                for (int i = 0; i < statuses.length; i++) {
                  statuses[i]['isChecked'] = i == index ? value! : false;
                }
              });
            }
          },
        ),
        Text(
          statuses[index]['label'], // Access the label from the map
          style: GoogleFonts.quicksand(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget showOnlyDetails(JobModel job) {
    String formattedEndTimeDate = '';
    if (job.endTime != null) {
      DateTime parsedDate = DateTime.parse(job.endTime ?? "");
      formattedEndTimeDate =
          DateFormat('dd MMM yyyy hh:mm a').format(parsedDate);
    }
    return ListView(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.customerName ?? '',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      //formatStrDate(job.pickUpDate ?? '0001-01-01') ?? '',
                      formatStrDate(job.pickUpDate ?? '') ?? "",
                      style: GoogleFonts.quicksand(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    showImagePopup(context, job.logo);
                  },
                  icon: Icon(Icons.link_rounded))
            ],
          ),
        ),
        Container(
          color: Colors.blueAccent,
          width: double.maxFinite,
          height: 2,
          margin: const EdgeInsets.fromLTRB(26, 0, 26, 0),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /*Column(
                      children: [
                        Text(
                          'Pick Up Date',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          //'${formatStrDate(job.pickUpDate ?? '')}',
                          formatStrDate(job.App_startDate ?? '') ?? "",
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),*/
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pickup Time',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          convertTo12HourFormat(job.pickUpTime ?? ''),
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Column(
                  children: [
                    Text(
                      'Sales ID',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.salesID ?? '',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /*Column(
                      children: [
                        Text(
                          'Issued By',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.issuedBy ?? '',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),*/
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service Type',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.serviceType.toString(),
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transfer Type',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.transferType.toString(),
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    /*Column(
                      children: [
                        Text(
                          'Car Reg. No.',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.carRegNo ?? '',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),*/
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Type',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.carType ?? '',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer/Booking Agent',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.customerBookingAgent ?? '',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              /*Padding(
                padding:
                const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  children: [
                    Text(
                      'Driver Name',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.driverName ?? '',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Passenger Name',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.passengerName ?? '',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reference',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.reference ?? '',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tel no.',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.telNo ?? '',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flight No.',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.flightNo ?? '',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'ETA/ETD',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          /*formatStrDate(job.eTAETD ??
                              '0001-01-01') ??
                              '',*/
                          formatStrTime(job.eTAETD ?? '') ?? '',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pickup Address',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.pickupAddress ?? '',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drop off Address',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.dropoffAddress ?? '',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'END TIME',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedEndTimeDate,
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remarks/Special Instructions',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      job.Remarks ?? '',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      statuses.length,
                      (index) =>
                          buildCheckbox(index, false, job.appStatus ?? 0)),
                ),
              )
            ],
          ),
        ),
        job.customerSignature != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Signature",
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w900),
                    ),
                    Image.memory(
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width,
                      base64Decode(
                        job.customerSignature,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        job.Driver_latlong!.isEmpty
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Point",
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                        height: 300,
                        width: double.maxFinite,
                        child: MapSample(
                          title: "Start Point",
                          latLngString: job.Driver_latlong ?? '',
                        )),
                  ],
                ),
              ),
        job.Customer_latlong!.isEmpty
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "End Point",
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                        height: 300,
                        width: double.maxFinite,
                        child: MapSample(
                          title: "End Point",
                          latLngString: job.Customer_latlong ?? '',
                        )),
                  ],
                ),
              ),
        job.driverSignature != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Driver Signature",
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w900),
                    ),
                    Image.memory(
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                        base64Decode(job.driverSignature)),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  void showImagePopup(BuildContext context, var base64) {
    base64 == null || base64.toString().isEmpty
        ? notify("No Attachment")
        : showDialog(
            context: context,
            barrierColor: Colors.black54, // Background overlay color
            barrierDismissible: true, // Allow dismiss by tapping outside
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent, // Transparent background
                insetPadding: EdgeInsets.all(10), // Padding around the popup
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjust size to fit the content
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                      /*child: Image.asset(
                  "assets/images/cnplogo.png",
                  fit: BoxFit.cover,
                ),*/
                      child: base64 == null || base64.toString().isEmpty
                          ? SizedBox()
                          : Image.memory(
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.contain,
                              base64Decode(base64),
                            ),
                    )
                  ],
                ),
              );
            },
          );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        DateTime now = DateTime.now();

        fullDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );

        print("Selected DateTime: $fullDateTime");
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm(); // 12-hour => e.g., 5:08 PM
    // final format = DateFormat.Hm(); // 24-hour => e.g., 17:08
    return format.format(dt);
  }
}
