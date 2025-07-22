import 'package:flutter/material.dart';
import 'package:minimalist/core/media.dart';

class MyHeaderDrawer extends StatelessWidget{
  const MyHeaderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.lightBlue[900],
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(Media.logo),
            const SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}