import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

itemDashboard(
        {String? point,
        String? title,
        IconData? iconData,
        Color? background,
        BuildContext? context, EdgeInsetsGeometry? margin}) =>
    Container(
      margin: margin ?? const EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      width: double.infinity,
      decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context!).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: title!.isNotEmpty ? CrossAxisAlignment.end : CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: background)),
              const SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(point!,
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16)),
                  ),
                 title!.isNotEmpty ? Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      title!.toUpperCase(),
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ) : SizedBox(),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_right_alt_rounded, color: Colors.white)
        ],
      ),
    );
