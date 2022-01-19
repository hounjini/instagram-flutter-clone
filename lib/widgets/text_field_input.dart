import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  TextFieldInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType})
      : super(key: key);
  final TextEditingController textEditingController;
  bool isPass;
  final String hintText;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      //들어갈 문자에 대한 정의
      keyboardType: textInputType,
      //입력한 것 가릴지 말지.
      obscureText: isPass,
    );
  }
}
