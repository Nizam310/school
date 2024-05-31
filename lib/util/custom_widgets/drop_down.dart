import 'package:flutter/material.dart';

class CusDropDown extends StatelessWidget {
  final Object val;
  final Function(Object?) onChanged;
  const CusDropDown({super.key, required this.val, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Object>(
        items: <Object>[]
            .map((e) => DropdownMenuItem<Object>(
            value: e,
            child: Text(e.toString())))
            .toList(),
        onChanged: onChanged);
  }
}
