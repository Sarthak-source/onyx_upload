import 'package:flutter/material.dart';
import 'package:onyx_upload/core/extensions/widgets/responsive/responsive_ext.dart';
import 'package:onyx_upload/core/style/app_colors.dart';

class Utils {
  Utils._();

  /// custom open PopUp Dialog
  static customUploadDialog(BuildContext context,
          {double? width, double? height, required Widget widget}) =>
      showDialog(
        barrierColor: Colors.white,
        context: context,
        builder: (context) => Dialog(
          backgroundColor: kColapsColor,
          surfaceTintColor: kColapsColor,
          shadowColor: kColapsColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: width ??
                (context.isDesktop ? context.width * 0.5 : context.width * 0.8),
            padding: const EdgeInsets.all(12.0),
            child: widget,
          ),
        ),
      );
}
