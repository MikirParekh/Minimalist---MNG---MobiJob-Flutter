import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:minimalist/core/c_text.dart';
import 'package:minimalist/core/loader.dart';
import 'package:minimalist/core/media.dart';
import 'package:minimalist/screen/dashboard/view/home_page.dart';
import 'package:minimalist/screen/login/bloc/login_bloc/login_bloc.dart';
import 'package:minimalist/service/secure_storage_service.dart';
import 'package:minimalist/widget/custom_text_form_field.dart';
import 'package:minimalist/widget/toast_notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPage createState() => _LoginPage();

  static const path = '/login';
}

class _LoginPage extends State<LoginPage> {
  bool cbRememberMe = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginBloc loginBloc = LoginBloc();
  final SecureStorageService _storageService = SecureStorageService();

  bool onsecure = false;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginLoading) {
            LoaderUtils(context).startLoading();
          } else if (state is LoginSuccess) {
            await _storageService.writeData(
                CText.userId, state.loginRespModel.data!.userId ?? '');
            await _storageService.writeData(
                CText.driverNo, state.loginRespModel.data!.driverNo ?? '');
            LoaderUtils(context).stopLoading();
            context.go(Dashboard.path);
          } else if (state is LoginError) {
            LoaderUtils(context).stopLoading();
            notify(state.error);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.lightBlue[900],
          body: Stack(
            children: [
              Positioned(
                top: -10,
                left: -5,
                right: -5,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: Card(
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 120,
                        ),
                        SizedBox(
                          height: 200,
                          width: 300,
                          child: Image.asset(Media.logo),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 25,
                right: 25,
                child: Card(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      )),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextFormField(
                          controller: usernameController,
                          labelText: "Username",
                          prefixIcon: const Icon(CupertinoIcons.person_fill),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextFormField(
                          controller: passwordController,
                          labelText: "Password",
                          prefixIcon: const Icon(CupertinoIcons.lock_fill),
                          obscureText: onsecure,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  onsecure = !onsecure;
                                });
                              },
                              icon: Icon(onsecure
                                  ? CupertinoIcons.eye_fill
                                  : CupertinoIcons.eye_slash_fill)),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (usernameController.text.trim().isEmpty) {
                              notify("Please Enter Username");
                              return;
                            }
                            if (passwordController.text.trim().isEmpty) {
                              notify("Please Enter Password");
                              return;
                            }
                            loginBloc.add(LoginButtonPressed(
                                password: passwordController.text,
                                username: usernameController.text));
                          },
                          height: 50,
                          minWidth: 360,
                          color: Colors.lightBlue[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Can't access your account",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Forgot Password",
                          style: TextStyle(
                              fontSize: 13, color: Colors.lightBlue[900]),
                        ),
                      ],
                    ),*/
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -70,
                left: -5,
                right: -30,
                child: SizedBox(
                  height: 100,
                  child: Card(
                    color: Colors.grey[300],
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
