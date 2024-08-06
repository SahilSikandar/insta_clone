import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class Kbutton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final void Function()? onTap;
  const Kbutton(
      {super.key,
      required this.onTap,
      this.isLoading = false,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14),
        width: double.infinity,
        decoration: BoxDecoration(
            color: blueColor, borderRadius: BorderRadius.circular(4)),
        child: Text(
          text,
          style: const TextStyle(
            //color: mobileBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
