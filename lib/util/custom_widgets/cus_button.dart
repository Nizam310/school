import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:school/util/color.dart';

class CusButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  const CusButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: AppColor.buttonColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          text,
          textAlign: TextAlign.center,
          style:
              context.textTheme.bodySmall?.copyWith(color: AppColor.onPrimary),
        )),
      ),
    );
  }
}
