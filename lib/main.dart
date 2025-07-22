import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:minimalist/core/app_router.dart';
import 'package:minimalist/screen/dashboard/bloc/count_bloc.dart';
import 'package:minimalist/service/secure_storage_service.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final context = SecurityContext.defaultContext;
  context.allowLegacyUnsafeRenegotiation = true;
  await SecureStorageService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: BlocProvider(
        create: (context) => CountBloc(),
        child: MaterialApp.router(
          routerConfig: router,
          title: 'C & P Rent-A-Car',
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}


