import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist/screen/job_list/repo/job_repo.dart';
import 'package:minimalist/screen/login/repo/login_repo.dart';
import 'package:minimalist/screen/logout/logout.dart';
import 'package:minimalist/widget/custom_text_form_field.dart';
import 'package:minimalist/widget/toast_notification.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  static const path = '/resetPassword';

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController currentController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    currentController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Reset Password",
          style: GoogleFonts.quicksand(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              /*CustomTextFormField(
                controller: currentController,
                labelText: "Current Password",
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
              ),
              const SizedBox(
                height: 16,
              ),*/
              CustomTextFormField(
                controller: passwordController,
                labelText: "New Password",
                prefixIcon: const Icon(CupertinoIcons.lock_fill),
              ),
              Expanded(child: SizedBox()),
              MaterialButton(
                onPressed: () async {
                  /* if(currentController.text.toString().isEmpty){
                    notify("Please Enter Current Password");
                    return;
                  }*/

                  var activeStatus = await JobRepository().isActiveStatus();

                  if (activeStatus == true) {
                    if (passwordController.text.toString().isEmpty) {
                      notify("Please Enter New Password");
                      return;
                    }
                    await LoginRepository().resetPassword(
                        context,
                        currentController.text.toString(),
                        passwordController.text.toString());
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => LogoutDialogBox(
                        isPermitted: false,
                      ),
                    );
                  }
                },
                height: 50,
                minWidth: 360,
                color: Colors.lightBlue[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
