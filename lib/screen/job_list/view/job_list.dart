import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist/core/extension.dart';
import 'package:minimalist/screen/dashboard/bloc/count_bloc.dart';
import 'package:minimalist/screen/job_details/view/job_details.dart';
import 'package:minimalist/screen/job_list/bloc/get_job_bloc/get_job_bloc.dart';
import 'package:minimalist/utils/util.dart';
import 'package:minimalist/widget/toast_notification.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class JobList extends StatefulWidget {
  final int status;

  const JobList({super.key, required this.status});

  @override
  _JobList createState() => _JobList();

  static const path = '/jobList';
}

class _JobList extends State<JobList> {
  GetJobBloc getJobBloc = GetJobBloc();

  @override
  void initState() {
    super.initState();
    callList();
    context.read<CountBloc>().add(FetchCount());
  }

  void callList() {
    getJobBloc.add(
      FetchJobEvent(
        status: widget.status,
        fromDate: widget.status == 1
            ? DateTime.now().add(Duration(days: 1)).toFormattedString()
            : DateTime.now().toFormattedString(),
        toDate: widget.status == 1
            ? DateTime.now().add(Duration(days: 1)).toFormattedString()
            : DateTime.now().toFormattedString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getJobBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[900],
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.status == 0
                ? "Today's Jobs List"
                : widget.status == 1
                    ? "Tomorrow's Jobs List"
                    : widget.status == 2
                        ? "Today's Completed Jobs List"
                        : "Pending Sign Job",
            style: GoogleFonts.quicksand(color: Colors.white),
          ),
          actions: [
            widget.status != 0
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        List<String>? dates =
                            await selectFromDate(context, widget.status);
                        if (dates != null) {
                          String fromDate = dates[0];
                          String toDate = dates[1];
                          getJobBloc.add(FetchJobEvent(
                              status: widget.status,
                              fromDate: fromDate,
                              toDate: toDate));
                        } else {
                          debugPrint('No dates selected.');
                        }
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: BlocConsumer<GetJobBloc, GetJobState>(
            listener: (context, state) {
              if (state is GetJobError) {
                notify(state.error);
              }
            },
            builder: (context, state) {
              if (state is GetJobLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GetJobLoaded) {
                if (state.list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      var job = state.list[index];
                      return InkWell(
                        onTap: () {
                          context.read<CountBloc>().add(FetchCount());
                          context.push(JobDetails.path, extra: {
                            "jobNo": job.jobNo,
                            "listStatus": widget.status.toString(),
                          }).then((value) {
                            if (value == true) callList();
                          });
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Icon(Icons.account_balance),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          job.customerName ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          job.jobNo ?? '',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          '${formatStrDate(job.pickUpDate ?? '') ?? ""} ${formatStrTime(job.pickUpTime ?? '') ?? ''}',
                                          style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.maxFinite,
                              height: 1,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("No Data Found"),
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

Future<List<String>?> selectFromDate(BuildContext context, int status) async {
  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return await showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        //margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50), topLeft: Radius.circular(50)),
          ),
          shadows: [
            isDarkMode
                ? const BoxShadow()
                : BoxShadow(
                    color: const Color(0x2DBBC5C9),
                    blurRadius: 14,
                    offset: Offset(isDarkMode ? 0 : 1, 1),
                    spreadRadius: 6,
                  )
          ],
        ),
        child: SfDateRangePicker(
          showTodayButton: true,
          onCancel: () => Navigator.pop(context),
          showActionButtons: true,
          initialSelectedDate: DateTime.now(),
          minDate: status == 1
              ? DateTime.now().add(Duration(days: 1))
              : DateTime(1900),
          maxDate: status == 1 ? DateTime(2100) : DateTime.now(),
          onSubmit: (p0) {
            if (p0 is PickerDateRange) {
              var from = p0.startDate;
              var to = p0.endDate ?? from;
              if (from != null) {
                Navigator.pop(
                  context,
                  [from.toFormattedString(), to!.toFormattedString()],
                );
              } else {
                notify("Please Select Date");
              }
            } else {
              Navigator.pop(context);
            }
          },
          initialDisplayDate: DateTime.now(),
          monthViewSettings: DateRangePickerMonthViewSettings(
            dayFormat: 'EEE',
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              backgroundColor: Colors.transparent,
              textStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          backgroundColor: Colors.white,
          selectionMode: DateRangePickerSelectionMode.range,
          rangeSelectionColor: Colors.purple.shade100,
          selectionTextStyle: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Colors.white),
          todayHighlightColor: isDarkMode ? Colors.white : Colors.blue,
          headerHeight: 60,
          headerStyle: DateRangePickerHeaderStyle(
              backgroundColor: Colors.transparent,
              textStyle: Theme.of(context).textTheme.bodyLarge),
          monthCellStyle: DateRangePickerMonthCellStyle(
              todayTextStyle: Theme.of(context).textTheme.labelLarge),
        ),
      );
    },
  );
}
