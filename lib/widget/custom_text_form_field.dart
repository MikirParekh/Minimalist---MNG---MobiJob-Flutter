import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final int maxLine;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool? disable;


  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.maxLine = 1,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.disable,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disable ?? false,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLine,
        onTap: onTap,
        onTapOutside: (event) =>  FocusScope.of(context).unfocus(),
        style: Theme.of(context).textTheme.bodyLarge,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          hintText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
          labelText: labelText,
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          suffixIconColor: Colors.grey,
          prefixIconColor: Colors.grey,
          errorMaxLines: 3,
          errorBorder: InputBorder.none,
          errorStyle: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.red),
        ),
      ),
    );
  }
}