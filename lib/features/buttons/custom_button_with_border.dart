import 'package:flutter/material.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';

class CustomButtonWithBorder extends StatelessWidget {
  final String text;
  final Widget icon;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomButtonWithBorder({
    super.key,
    required this.text,
    required this.icon,
    required this.borderColor,
    this.textColor = kBlackText,
    required this.onPressed,
    this.borderRadius = 8.0,
    required this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding,
        side: BorderSide(color: borderColor), // Set border color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: backgroundColor, // Makes it outlined style
        shadowColor: Colors.transparent,
      ),
      icon: icon,
      label: Text(
        text,
        style: AppTextStyles.styleRegular12(context, color: textColor),
      ),
    );
  }
}
