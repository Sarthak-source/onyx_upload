import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/core/extensions/widgets/buttons/custom_text_icon_button.dart';
import 'package:onyx_upload/core/extensions/widgets/dropdowns/Customr_dopdown_with_search.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/show_mapping_dialog.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/title_dialog_page.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';

class UploadDialogBody extends StatelessWidget {
  const UploadDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl, // عكس اتجاه الواجهة
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // العنوان العلوي مع زر "إنشاء قالب جديد"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'استيراد ملف',
                      style: AppTextStyles.styleRegular14(context, color: Colors.black87),
                    ),
                    Row(
                      children: [
                        // زر الإغلاق
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
                  ],
                ),
              ),

              const SizedBox(height: 12),
               Row(
                
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                  ),
                  Text(
                    'اجعل اول صف في الملف هو العنوان',
                    style: AppTextStyles.styleRegular14(context, color: Colors.black),
                  ),const Spacer(), 
                  // زر "إنشاء قالب جديد"
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => const CreateTemplateFinalDialog(selectedColumns: [],),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: actionColors, 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            'إنشاء قالب جديد',
                            style: AppTextStyles.styleRegular14(context, color: Colors.white),
                          ),
                        ),
                ],
              ),const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: backgroundLightBlue,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: lightBlue,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    // الأيقونة والنص
                    Icon(Icons.cloud, size: 50, color: azureColor),
                    const SizedBox(height: 8),
                    Text(
                      "برجاء إختيار ملف excelsheet او csv للرفع",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.styleRegular14(context, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    CustomTextIconButton(
                      onPressed: () {
                      },
                      title: "رفع الملف",
                      icon: Icons.upload_file,
                      iconColor: Colors.blue,
                      bgColor: Colors.white,
                      borderColor: Colors.blue,
                      txtColor: Colors.blue,
                      iconSize: 20,
                      height: 35,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // منطقة القوالب (التصميم الجديد)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "القوالب المتاحة*",
                  style: AppTextStyles.styleMedium18(context, color: kTextColor),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomDropDownWithSearch(
                      fldNm: "templateDropdown",
                      hint: "اختر القالب",
                      list: const ["قالب 1", "قالب 2"],
                      isRequired: true,
                      onChanged: (value) {
                        log("تم اختيار القالب: $value");
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.remove_red_eye_outlined),
                  const SizedBox(width: 8),
                  CustomTextIconButton(
                    onPressed: () {},
                    title: "تحميل القالب",
                    icon: Icons.downloading_rounded,
                    iconColor: Colors.white,
                    bgColor: kCardGreenColor,
                    txtColor: Colors.white,
                    iconSize: 24,
                    height: 35,
                  ),
                ],
              ),
              
            ],
          ),
        );
      },
    );
  }
}