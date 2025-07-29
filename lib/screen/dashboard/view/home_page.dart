import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist/screen/dashboard/bloc/count_bloc.dart';
import 'package:minimalist/screen/dashboard/model/count_model.dart';
import 'package:minimalist/screen/dashboard/model/get_status_model.dart';
import 'package:minimalist/screen/job_list/view/job_list.dart';
import 'package:minimalist/screen/logout/logout.dart';
import 'package:minimalist/screen/privacy/privacypolicy.dart';
import 'package:minimalist/screen/reset_password/view/reset_password.dart';
import 'package:minimalist/widget/item_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  MyDashboard createState() => MyDashboard();

  static const path = '/dashboard';
}

class MyDashboard extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    context.read<CountBloc>().add(FetchCount());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.lightBlue[900],
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('C & P Rent-A-Car(Pte) Ltd',
            style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.privacy_tip_outlined, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => PrivacyPolicyPage(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<CountBloc>().add(FetchCount());
            },
          ),
          SizedBox(
            width: 4,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<CountBloc>().add(FetchCount());
                },
                child: BlocListener<CountBloc, CountState>(
                  listener: (context, state) {
                    if (state is CountNotPermitted) {
                      showDialog(
                        context: context,
                        builder: (context) => LogoutDialogBox(
                            isPermitted: state.getStatusModel.data?.status
                            // ? true
                            // : false
                            ),
                      );
                    }
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BlocBuilder<CountBloc, CountState>(
                            builder: (context, state) {
                              if (state is CountLoading) {
                                return const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 100),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (state is CountSuccess) {
                                return taskManagementCounterWidget(
                                    state.countModel);
                              }
                              if (state is CountNotPermitted) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 50),
                                    Icon(
                                      Icons.cancel_outlined,
                                      size: 100,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      "You do not have Permission!",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                );
                              }
                              if (state is CountError) {
                                return Expanded(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(state.error),
                                        TextButton(
                                          onPressed: () => context
                                              .read<CountBloc>()
                                              .add(FetchCount()),
                                          child: Text("Retry"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Bottom Reset Password button
            InkWell(
              onTap: () {
                context.push(ResetPassword.path);
              },
              child: itemDashboard(
                  point: "Reset Password",
                  title: "",
                  iconData: Icons.lock_outlined,
                  background: Colors.blue,
                  context: context,
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8)),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => LogoutDialogBox(),
                );
              },
              child: itemDashboard(
                  point: "Logout",
                  title: "",
                  iconData: Icons.logout,
                  background: Colors.red,
                  context: context,
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskManagementCounterWidget(CountModel countModel) {
    return Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              context.push(JobList.path, extra: {"status": 0}).then(
                (value) {
                  context.read<CountBloc>().add(FetchCount());
                },
              );
            },
            child: itemDashboard(
                point: "Today's Jobs",
                title: '${countModel.data!.todayJobCount}',
                iconData: Icons.dashboard,
                background: Colors.blue,
                context: context,
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8)),
          ),
          InkWell(
            onTap: () {
              context.push(JobList.path, extra: {"status": 1}).then(
                (value) {
                  context.read<CountBloc>().add(FetchCount());
                },
              );
            },
            child: itemDashboard(
                point: "Tomorrow's Jobs",
                title: '${countModel.data!.tomorrowJobCount}',
                iconData: Icons.access_time_outlined,
                background: Colors.blue,
                context: context,
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8)),
          ),
          InkWell(
            onTap: () {
              context.push(JobList.path, extra: {"status": 2}).then(
                (value) {
                  context.read<CountBloc>().add(FetchCount());
                },
              );
            },
            child: itemDashboard(
              point: "Today's Completed Jobs",
              title: '${countModel.data!.completedJobCount}',
              iconData: Icons.account_balance_wallet_sharp,
              background: Colors.blue,
              context: context,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            ),
          ),
          InkWell(
            onTap: () {
              context.push(JobList.path, extra: {"status": 3}).then(
                (value) {},
              );
            },
            child: itemDashboard(
              point: "Pending Sign Jobs",
              title: '${countModel.data!.todayPendingSignJobCount}',
              iconData: Icons.pending_outlined,
              background: Colors.blue,
              context: context,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            ),
          ),
        ],
      ),
    );
  }
}
