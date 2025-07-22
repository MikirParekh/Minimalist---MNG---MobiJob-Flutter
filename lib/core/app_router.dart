import 'package:go_router/go_router.dart';
import 'package:minimalist/screen/dashboard/view/home_page.dart';
import 'package:minimalist/screen/job_details/view/job_details.dart';
import 'package:minimalist/screen/job_details/view/signature_pad.dart';
import 'package:minimalist/screen/job_list/view/job_list.dart';
import 'package:minimalist/screen/login/view/login_page.dart';
import 'package:minimalist/screen/privacy/privacypolicy.dart';
import 'package:minimalist/screen/reset_password/view/reset_password.dart';
import 'package:minimalist/screen/splash/view/splash.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: "splash",
      path: Splash.path,
      builder: (context, state) => const Splash(),
    ),
    GoRoute(
      name: "privacy",
      path: PrivacyPolicyPage.path,
      builder: (context, state) => const PrivacyPolicyPage(),
    ),
    GoRoute(
      name: 'login',
      path: LoginPage.path,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: 'resetPassword',
      path: ResetPassword.path,
      builder: (context, state) => const ResetPassword(),
    ),
    GoRoute(
      name: 'dashboard',
      path: Dashboard.path,
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      name: 'jobList',
      path: JobList.path,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        final int? status = data['status'] as int?;
        return JobList(status: status!,);
      },
    ),
    GoRoute(
      name: 'jobDetails',
      path: JobDetails.path,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        final String? jobNo = data['jobNo'] as String?;
        final String? listStatus = data['listStatus'] as String?;
        return JobDetails(jonNo: jobNo,listStatus: listStatus,);
      },
    ),
    GoRoute(
      name: 'signaturePad',
      path: SignaturePad.path,
      builder: (context, state) {
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        final String? jobNo = data['jobNo'] as String?;
        final String? status = data['status'] as String?;
        final String? remark = data['remark'] as String?;
        final bool? isPending = data['isPending'] as bool?;
        final String? pickTime = data['pickTime'] as String?;
        return SignaturePad(status: status,jonNo: jobNo,remark: remark,isPending: isPending,pickupTime: pickTime ?? '',);
      },
    ),
  ],
);
