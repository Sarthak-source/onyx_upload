import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/core/extensions/widgets/responsive/responsive_ext.dart';

part 'responsive_state.dart';

class ResponsiveCubit extends Cubit<ResponsiveState> {
  ResponsiveCubit() : super(ResponsiveInitial());
  bool sideMenuIsOpen = false;
  bool isFullScreen = false;
  double width = 0.0;

  // void toggleFullScreen() {
  //   isFullScreen = !isFullScreen;
  //   FullScreenWindow.setFullScreen(isFullScreen);
  //   emit(ToggleFullScreenState());
  // }

  double getWidth(BuildContext context,{
    double? ratioMobile, // ratio to get width for mobile only
    double? ratioDesktop,   // ratio to get width for Desktop only
    double? ratioDesktopOpenSideMenu,   // ratio to get width for Desktop only
    double? ratioTablet, // ratio to get width for Tablet only
  }) {

    // width will return after calculate
    double widthOfRatioItem = 0.0;

    // width Screen Now
    double widthScreenNow = sideMenuIsOpen
        ? context.width - (context.width * 0.18)
        : context.width;

    // check if isMobile && isTablet && isDesktop
    bool isMobile = context.width < 600;
    bool isTablet = context.width < 1200 && context.width > 600;
    bool isDesktop = context.width >= 1200;

    /// calculate width
    if(isMobile){
      widthOfRatioItem = widthScreenNow * (ratioMobile ?? 0.0);
    }
   else if(isTablet){
      widthOfRatioItem = widthScreenNow * (ratioTablet ?? 0.0);
    }
   else if(isDesktop){
      widthOfRatioItem = widthScreenNow *
      (sideMenuIsOpen
          ? (ratioDesktopOpenSideMenu ?? ratioDesktop ?? 0.0)
          : (ratioDesktop ?? 0.0));
    }
    return widthOfRatioItem;
  }

  double getHeight(BuildContext context,{
    double? ratioMobile, // ratio to get height for mobile only
    double? ratioDesktop,   // ratio to get height for Desktop only
    double? ratioTablet, // ratio to get height for Tablet only
    double? ratioTabletPortrait, // ratio to get height for Tablet only
  }) {
    // height will return after calculate
    double heightOfRatioItem = 0.0;

    // height Screen Now
    double heightScreenNow = context.height;

    // check if isMobile && isTablet && isDesktop
    bool isMobile = context.width < 600;
    bool isTablet = context.width < 1200 && context.width > 600;
    bool isDesktop = context.width >= 1200;

    /// calculate height
    if(isMobile){
      heightOfRatioItem = heightScreenNow * (ratioMobile ?? 0.0);
    }
    else if(isTablet){
      if(context.orientation == Orientation.portrait){
        heightOfRatioItem = heightScreenNow * (ratioTabletPortrait ?? 0.0);
      }
      else{
        heightOfRatioItem = heightScreenNow * (ratioTablet ?? 0.0);
      }
    }
    else if(isDesktop){
      heightOfRatioItem = heightScreenNow * (ratioDesktop ?? 0.0);
    }
    return heightOfRatioItem;
  }


  bool isMobile(BuildContext context) {
    width = context.width;
    return MediaQuery.of(context).size.width < 600;
  }

  bool isTablet(BuildContext context) {
    width = context.width;
    return MediaQuery.of(context).size.width < 1200 &&
        MediaQuery.of(context).size.width > 600;
  }

  bool isDesktop(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 1200 && sideMenuIsOpen) {
      width = context.width - (context.width * 0.18);
    } else {
      width = context.width;
    }
    return MediaQuery.of(context).size.width >= 1200;
  }

  bool isPortrait(BuildContext context) =>
      context.orientation == Orientation.portrait;

  initResponsive(BuildContext context) {
    if (context.width >= 1200) {
      width = context.width - (context.width * 0.18);
    } else {
      width = context.width;
    }
    emit(InitResponsiveState());
  }

  closeSideMenu(BuildContext context) {
    sideMenuIsOpen = !sideMenuIsOpen;
    if (context.width >= 1200 && sideMenuIsOpen) {
      width = context.width - (context.width * 0.18);
    } else {
      width = context.width;
    }
    emit(CloseSideMenuState());
  }
}

extension on BuildContext {
  get orientation => null;
}
