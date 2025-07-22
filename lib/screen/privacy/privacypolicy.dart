import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  static const path = "/privacy";

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
    InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    webViewController!.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            PrivacyPolicyAppbar(),
            Expanded(
              child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                            cacheEnabled: false
                        ),
                      ),
                      onWebViewCreated: (controller) async {
                        webViewController = controller;
                        print(await controller.getUrl());
                      },
                      onLoadStart: (controller, url) async {
                        setState(() {
                          isLoading = true;
                        });
                      },
                      onLoadStop: (controller, url) async {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      initialUrlRequest: URLRequest(url: WebUri('https://www.moby.sg/general-8')),
                    ),
                    isLoading? const Center(
                      child: CircularProgressIndicator(),
                    ): const SizedBox()
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }

    AppBar PrivacyPolicyAppbar() {
      return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.blue, //change your color here
        ),
        elevation: .5,
        title: Text(
          "Privacy Policy",
          style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
      );
    }
}