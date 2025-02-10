// import 'package:flutter/material.dart';
// import 'package:onyx_upload/core/extensions/responsive_ext.dart';

// class AdaptiveWrap extends StatelessWidget {
//   final Widget mobile;
//   final Widget desktop;
//   final Widget? tablet;

//   const AdaptiveWrap({
//     super.key,
//     this.tablet,
//     required this.mobile,
//     required this.desktop,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (context.isDesktop) {
//       return desktop;
//     } else if (context.isTablet && tablet != null) {
//       return tablet!;
//     } else {
//       return mobile;
//     }
//   }
// }