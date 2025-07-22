import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minimalist/core/c_text.dart';
import 'package:minimalist/core/media.dart';
import 'package:minimalist/screen/dashboard/view/home_page.dart';
import 'package:minimalist/screen/login/view/login_page.dart';
import 'package:minimalist/service/secure_storage_service.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();

  static const path = '/';
}

class _SplashState extends State<Splash> {
  final SecureStorageService _storageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future navigateToNextScreen() async{
    var isUserLoggedIn = await _storageService.readData(CText.userId);
    if(isUserLoggedIn != null  && isUserLoggedIn.isNotEmpty) {
      if(!mounted) return;
      context.go(Dashboard.path);
    }else{
      Timer(const Duration(seconds: 2), () {
        context.go(LoginPage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Media.logo),
      ),
    );
  }
}
