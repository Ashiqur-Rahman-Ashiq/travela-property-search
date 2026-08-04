import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final bool isRequiredFill;
  final void Function(String value)? onChanged;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final int maxLines;
  final Color borderColor;

  const CustomTextFieldWidget({
    super.key,
    this.hintText = 'Write something...',
    this.labelText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.isPassword = false,
    this.isRequiredFill = false,
    this.onChanged,
    this.validator,
    this.isEnabled = true,
    this.maxLines = 1,
    this.borderColor = const Color(0xFFBFBFBF),
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      enabled: widget.isEnabled,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
      obscureText: widget.isPassword ? _obscureText : false,
      onFieldSubmitted: (_) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(Dimensions.fontSizeDefault),
        label: widget.labelText != null ? Text.rich(TextSpan(children: [
          TextSpan(text: widget.labelText!),
          if (widget.isRequiredFill) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
        ])) : null,
        hintText: widget.hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: widget.borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: widget.borderColor)),
        suffixIcon: widget.isPassword ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).primaryColor.withValues(alpha: .6)),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ) : null,
      ),
    );
  }
}
