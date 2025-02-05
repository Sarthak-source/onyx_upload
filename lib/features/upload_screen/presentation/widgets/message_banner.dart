import 'package:flutter/material.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';

class MessageBanner extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;

  const MessageBanner({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor,width: 1),
      ),
      child: Align(
        alignment: Alignment.centerLeft, // Left-aligned text
        child: Text(
          message,
          style: AppTextStyles.styleRegular14(context, color: textColor),
        ),
      ),
    );
  }
}
