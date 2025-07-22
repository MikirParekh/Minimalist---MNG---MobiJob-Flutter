import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

void notify(String msg, {ToastificationType? toastificationType}) {
  toastification.dismissAll();
  toastification.show(
    title: Text(msg,style: GoogleFonts.quicksand(),maxLines: 10,),
    autoCloseDuration: const Duration(seconds: 10),
    type: toastificationType ?? ToastificationType.error,
    style: ToastificationStyle.fillColored,
    showProgressBar: false,
    alignment: Alignment.bottomCenter,

  );
}