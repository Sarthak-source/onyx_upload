import 'package:flutter/material.dart';
import 'package:onyx_upload/core/extensions/responsive_ext.dart';
import 'package:onyx_upload/core/style/app_colors.dart';

class Utils {
  Utils._();

  /// custom open PopUp Dialog
  static customOpenPopUpDialog(BuildContext context,
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

//   static Future<void> userAuthentacation(
//       {required String title,
//       required String buttunTitle,
//       required BuildContext context}) {
//     return customOpenPopUpDialog(context,
//         widget: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DialogTitleHeader(
//               title,
//             ),
//             const HSpacer(10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                     child: CustomTextFieldPurchase(
//                   isRequired: true,
//                   hint: "user_name",
//                 )),
//                 const WSpacer(10),
//                 Expanded(
//                     child: CustomTextFieldPurchase(
//                   isRequired: true,
//                   hint: "password",
//                 )),
//               ],
//             ),
//             CustomButton(
//               circularRadius: 5.0,
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               bgcColor: homeButtonColor,
//               height: 40,
//               width: 150,
//               title: buttunTitle,
//             )
//           ],
//         ));
//   }

//   void showNetworkErrorDialog(BuildContext? context, dynamic onTap) {
//     showCupertinoDialog(
//       context: context!,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           content: const Text(
// //          translator.currentLanguage == "en"
// //              ? "please check your internet connection"
// //              :
//             'تأكد من الاتصال بالانترنت',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w700,
//               // color: AppTheme.primaryColor,
//               // fontFamily: AppTheme.fontName
//             ),
//           ),
//           actions: <Widget>[
//             CupertinoButton(
//               onPressed: onTap,
//               child: const Text(
// //              translator.currentLanguage == "en"
// //                  ? "Try again"
// //                  :
//                 'حاول مرة أخرى',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   // color: AppTheme.secondaryColor,
//                   // fontFamily: AppTheme.boldFont
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   static Future<void> setupMobileAndDesktopExitWarning(
//     BuildContext context, {
//     double? width,
//     double? height,
//     String? image,
//     String? title,
//     String? message,
//     String? buttonYesText,
//     Color? buttonYesBkgColor,
//     String? buttonNoText,
//     Function()? yesPressed,
//     Function()? noPressed,
//   }) async {
//     await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         surfaceTintColor: kColapsColor,
//         shadowColor: shadowColor,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         content: Stack(
//           alignment: AlignmentDirectional.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(image ?? AppAssets.alertOnExit,
//                       height: 50, width: 50),
//                   const HSpacer(4),
//                   Text(
//                     title ?? 'warning_title',
//                     textAlign: TextAlign.center,
//                     style: AppTextStyles.styleLight14(context,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: kTextColor),
//                   ),
//                   const HSpacer(4),
//                   Text(
//                     message ?? 'warning_message',
//                     textAlign: TextAlign.center,
//                     style: AppTextStyles.styleLight14(context, color: kTextColor),
//                   ),
//                 ],
//               ),
//             ),
//             PositionedDirectional(
//               end: 10,
//               top: 10,
//               child: CustomInkIconBtn(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 marginHorizontal: 2,
//                 icon: Icons.clear,
//                 iconColor: kTextFiledColor,
//                 bgColor: kGrayIX,
//                 isCircleShape: true,
//                 iconSize: 15,
//               ),
//             ),
//           ],
//         ),
//         contentPadding: EdgeInsets.zero,
//         alignment: Alignment.center,
//         actionsAlignment: MainAxisAlignment.center,
//         actionsPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//         actions: [
//           CustomButton(
//             circularRadius: 8,
//             bgcColor: buttonYesBkgColor ?? homeButtonColor,
//             width: context.getWidth(
//                 ratioTablet: 0.18, ratioDesktop: 0.18, ratioMobile: 0.28),
//             height: 40,
//             onPressed: yesPressed,
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             title: buttonYesText ?? 'yes',
//           ),
//           CustomButton(
//             circularRadius: 8,
//             bgcColor: kTextFiledColor,
//             width: context.getWidth(
//                 ratioTablet: 0.18, ratioDesktop: 0.18, ratioMobile: 0.28),
//             height: 40,
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             onPressed: noPressed,
//             title: buttonNoText ?? 'no',
//           ),
//         ],
//       ),
//     ); // If dialog is dismissed without a value, return false
//   }
}
