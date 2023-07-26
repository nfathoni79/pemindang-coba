import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.prefixText,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.obscureText = false,
    this.smallPadding = false,
    this.enabled,
  });

  final TextEditingController? controller;
  final String? labelText;
  final Icon? prefixIcon;
  final String? prefixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool smallPadding;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelText: labelText,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        contentPadding: smallPadding
            ? const EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            : null,
      ),
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      enabled: enabled,
    );
  }
}
