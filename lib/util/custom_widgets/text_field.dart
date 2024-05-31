import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/util/color.dart';
import 'package:school/util/color.dart';

class CusTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool showText;
  final Widget? suffix;
  final int? maxLines;
  final bool? enable;
  final TextInputType? keyBoardType;
  final String? Function(String?)? validator;

  const CusTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.showText,
    this.suffix,
    this.enable,
    this.keyBoardType,
    this.validator,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(10),
    );
    return TextFormField(
      maxLines: maxLines ?? 1,
      enabled: enable ?? true,
      obscureText: showText,
      controller: controller,
      keyboardType: keyBoardType ?? TextInputType.name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppColor.onPrimary),
      decoration: InputDecoration(
        errorMaxLines: 3,
        enabled: true,
        labelText: label,
        labelStyle: const TextStyle(color: AppColor.onPrimary),
        /*  fillColor: const Color(0xFFFFFFFF),
        filled: true,*/
        border: border,
        suffix: suffix,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
      ),
      onTapOutside: (val) {
        Get.focusScope?.unfocus();
      },
      validator: validator,
    );
  }
}

enum Validator{
  name,age,
}