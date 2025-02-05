import 'package:flutter/material.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';

class TitleDialogPage extends StatelessWidget {
  const TitleDialogPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.styleLight12(context,
                color: kTextColor, fontSize: 16),
          ),
          InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: kGrayIX,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: kTextFiledColor,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
