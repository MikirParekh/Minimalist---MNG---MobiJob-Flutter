import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist/core/c_text.dart';
import 'package:minimalist/screen/splash/view/splash.dart';
import 'package:minimalist/service/secure_storage_service.dart';

class LogoutDialogBox extends StatefulWidget {
  final bool? isPermitted;

  const LogoutDialogBox({Key? key, this.isPermitted}) : super(key: key);

  @override
  State<LogoutDialogBox> createState() => _LogoutDialogBoxState();
}

class _LogoutDialogBoxState extends State<LogoutDialogBox> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Log out",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Text(
                widget.isPermitted == false
                    ? "You do not have permission!"
                    : "Are you sure you want to log out? You'll need to login again to use the app.",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: Row(
                children: <Widget>[
                  widget.isPermitted == true
                      ? Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.lightBlue,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: Center(
                                    child: Text(
                                  "Cancel",
                                  style: GoogleFonts.quicksand(
                                      color: Colors.lightBlue[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            final SecureStorageService _storageService =
                                SecureStorageService();
                            await _storageService.writeData(CText.userId, '');
                            GoRouter.of(context).go("/");
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // <-- Radius
                            ),
                            backgroundColor: Colors.lightBlue[900],
                          ),
                          child: Text(
                            "Log out",
                            style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}
