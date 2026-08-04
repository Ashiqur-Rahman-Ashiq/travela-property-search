import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/images.dart';

class CustomToast extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final SnackBarType sanckBarType;

  const CustomToast({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFF25282b),
    this.textColor = Colors.white,
    this.borderRadius = 30,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    required this.sanckBarType
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(50)
            ),
            padding: padding,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(sanckBarType == SnackBarType.success ? Images.snackbarTickmark :
              sanckBarType == SnackBarType.warning ? Images.snackbarWarning :  Images.snackbarError,
                  width: 17, height: 17),

              const SizedBox(width: Dimensions.paddingSizeSmall),
              Flexible(child: Text(text, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: textColor), maxLines: 3)),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
