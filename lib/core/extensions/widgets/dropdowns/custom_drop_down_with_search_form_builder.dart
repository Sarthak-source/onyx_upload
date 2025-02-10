// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:dropdown_button2/src/dropdown_button2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:onyx_upload/core/extensions/responsive_ext.dart';
// import 'package:onyx_upload/core/style/app_colors.dart';
// import 'package:onyx_upload/core/style/app_text_styles.dart';

// class CustomDropDownWithSearchBuilder extends HookWidget {
//   const CustomDropDownWithSearchBuilder({
//     super.key,
//     required this.fldNm,
//     this.initialValue,
//     this.width,
//     this.height,
//     this.labelText,
//     this.errorText,
//     this.isRequired = false,
//     this.enableSearch = false,
//     this.fillColor,
//     this.suffixIcon,
//     this.textInputType,
//     this.validator,
//     this.prefixIcon,
//     this.label,
//     this.readOnly = false,
//     this.textInputFormatter,
//     this.bgColor,
//     this.onChanged,
//     // this.selectedItem,
//     this.borderColor,
//     this.onMenuStateChange,
//     required this.hint,
//     required this.list,
//     this.autofocus = false,
//   });

//   final String? fldNm;
//   final String? initialValue;
//   final String? hint;
//   final String? labelText;
//   final String? errorText;
//   final Widget? label;
//   final TextInputType? textInputType;
//   final List<TextInputFormatter>? textInputFormatter;
//   final String? Function(String?)? validator;
//   final Widget? suffixIcon;
//   final Color? fillColor;
//   final IconData? prefixIcon;
//   final bool readOnly;
//   final bool enableSearch;
//   final bool isRequired;
//   final double? width;
//   final double? height;
//   final List list;
//   // final String? selectedItem;
//   final Function(String? value)? onChanged;
//   final Function(bool)? onMenuStateChange;
//   final Color? borderColor;
//   final Color? bgColor;
//   final bool autofocus;

//   @override
//   Widget build(BuildContext context) {
//     final searchController = useTextEditingController();
//     final focusNode = useFocusNode();

//     useEffect(() {
//       if (autofocus) {
//         WidgetsBinding.instance
//             .addPostFrameCallback((_) => focusNode.requestFocus());
//       }
//       return null;
//     }, []);

//     return FormBuilderField<String?>(
//         name: fldNm!,
//         // initialValue: initialValue,
//         builder: (FormFieldState field) {
//           return Center(
//             child: DropdownButtonHideUnderline(
//               child: DropdownButtonFormField2<String>(
//                 isExpanded: true,
//                 focusNode: focusNode,
//                 decoration: InputDecoration(
//                   floatingLabelBehavior: field.value != null
//                       ? FloatingLabelBehavior.always
//                       : FloatingLabelBehavior.auto,
//                   constraints: BoxConstraints(
//                     minHeight: height ?? 40,
//                     maxHeight: 60,
//                   ),
//                   label: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
//                     child: RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: hint,
//                             style: AppTextStyles.styleLight12(
//                               context,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           TextSpan(
//                             text: isRequired ? ' *' : '  ',
//                             style: AppTextStyles.styleLight12(
//                               context,
//                               color: Colors.red,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   contentPadding: EdgeInsets.zero,
//                   floatingLabelStyle: AppTextStyles.styleLight12(context),
//                   helperStyle: AppTextStyles.styleLight12(context),
//                   labelStyle:
//                       AppTextStyles.styleLight12(context, color: kBlackText),
//                   hintStyle: AppTextStyles.styleLight12(context,
//                       color: kTextFieldColor),
//                   errorStyle: AppTextStyles.styleLight12(context,
//                       color: kButtonRedDark, fontSize: 8),
//                   filled: true,
//                   isDense: true,
//                   fillColor: readOnly ? kColapsColor : fillColor ?? whiteColor,
//                   enabledBorder: const UnderlineInputBorder(
//                     borderSide: BorderSide(color: dividerColor),
//                   ),
//                   focusedBorder: const UnderlineInputBorder(
//                     borderSide: BorderSide(color: dividerColor),
//                   ),
//                   border: const UnderlineInputBorder(
//                     borderSide: BorderSide(color: dividerColor),
//                   ),
//                   errorBorder: const UnderlineInputBorder(
//                     borderSide: BorderSide(color: kButtonRedDark),
//                   ),
//                 ),
//                 customButton: CustomDropDownButton2(
//                   isRequired: isRequired,
//                   width: width,
//                   selectedValue: field.value,
//                   label: hint ?? '',
//                 ),
//                 items: list
//                     .map(
//                       (item) => DropdownItem(
//                         value: item.toString(),
//                         child: Container(
//                           height: 40,
//                           width: context.width,
//                           decoration: const BoxDecoration(
//                             border: Border(
//                               bottom: BorderSide(color: dividerColor),
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               item,
//                               textAlign: TextAlign.center,
//                               style: AppTextStyles.styleLight12(context),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                     .toList(),
//                 onChanged: readOnly ? null : onChanged,
//                 dropdownStyleData: DropdownStyleData(
//                   maxHeight: context.height * 0.4,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: whiteColor,
//                   ),
//                   scrollbarTheme: ScrollbarThemeData(
//                     radius: const Radius.circular(40),
//                     thickness: WidgetStateProperty.all<double>(6),
//                     thumbVisibility: WidgetStateProperty.all<bool>(true),
//                   ),
//                 ),
//                 menuItemStyleData: const MenuItemStyleData(
//                   padding: EdgeInsets.zero,
//                 ),
//                 dropdownSearchData: !enableSearch
//                     ? null
//                     : DropdownSearchData(
//                         searchController: searchController,
//                         // searchBarWidgetHeight: 40,
//                         // searchBarWidget: Container(
//                         //   height: 40,
//                         //   padding: const EdgeInsets.only(
//                         //     top: 8,
//                         //     bottom: 4,
//                         //     right: 8,
//                         //     left: 8,
//                         //   ),
//                         //   child: TextFormField(
//                         //     expands: true,
//                         //     maxLines: null,
//                         //     style: AppTextStyles.styleLight12(context),
//                         //     textInputAction: TextInputAction.done,
//                         //     controller: searchController,
//                         //     decoration: InputDecoration(
//                         //       isDense: true,
//                         //       focusedBorder: const OutlineInputBorder(
//                         //         borderSide: BorderSide(color: dividerColor),
//                         //       ),
//                         //       contentPadding: const EdgeInsets.symmetric(
//                         //         horizontal: 10,
//                         //         vertical: 8,
//                         //       ),
//                         //       hintText: 'search_for_item',
//                         //       hintStyle: AppTextStyles.styleLight12(context),
//                         //       border: OutlineInputBorder(
//                         //         borderRadius: BorderRadius.circular(8),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                         // noResultsWidget: Padding(
//                         //   padding: const EdgeInsets.all(8),
//                         //   child: Text(
//                         //     'No Item Found!',
//                         //     style: AppTextStyles.styleLight12(context),
//                         //   ),
//                         // ),
//                         searchMatchFn: (item, searchValue) {
//                           return item.value.toString().contains(searchValue);
//                         },
//                       ),
//                 onMenuStateChange: (isOpen) {
//                   if (!isOpen) {
//                     searchController.clear();
//                   }
//                 },
//                 validator: validator ??
//                     (value) {
//                       if (value == null) {
//                         return 'this_right_is_required';
//                       }
//                       return null;
//                     },
//               ),
//             ),
//           );
//         });
//   }
// }

// /// ===================== CustomDropDownButton =====================
// class CustomDropDownButton2 extends StatelessWidget {
//   const CustomDropDownButton2({
//     super.key,
//     this.height,
//     this.width,
//     required this.label,
//     this.selectedValue,
//     this.bgColor,
//     this.isRequired = false,
//     this.borderColor,
//   });

//   final double? width;
//   final double? height;
//   final String label;
//   final bool isRequired;
//   final Color? borderColor;
//   final Color? bgColor;
//   final String? selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: context.width,
//       constraints: BoxConstraints(minHeight: height ?? 35, maxHeight: 60),
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             child: Text(
//               selectedValue ?? '',
//               overflow: TextOverflow.ellipsis,
//               style: AppTextStyles.styleLight12(context),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
//             child: const Icon(
//               CupertinoIcons.chevron_down,
//               size: 10,
//               color: kTextFiledColor,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
