import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/core/extensions/widgets/dropdowns/Customr_dopdown_with_search.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/main_page_table.dart';

import '../controller/upload_screen_cubit.dart';

class CreateTemplateFinalDialog extends StatelessWidget {
  const CreateTemplateFinalDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => FileUploadCubit(),
        child: Dialog(
          backgroundColor: Color(0xFFF9F9F9),
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: 650,
            height: 450,
            child: Column(
              children: [
                // ====== العنوان العلوي للديالوج ======
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 0.5,)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ 
                        Text(
                          "إنشاء قالب جديد",
                          style: AppTextStyles.styleRegular14(context, color: Colors.black87),
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
                  ),
                ),

                // ====== حقل اسم القالب ======
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: CustomDropDownWithSearch(
                  fldNm: "templateDropdown",
                  hint: "اختر القالب",
                  list: const ["قالب 1", "قالب 2"], // يمكنك جعل هذه القائمة ديناميكية
                  isRequired: true,
                  onChanged: (value) {
                    log("تم اختيار القالب: $value");
                    // هنا يمكنك استدعاء دالة من الكيوبت لتحميل بيانات القالب المحدد
                  },
                ),)
                    ],
                  ),
                ),

                // ====== منطقة عرض الجدول (ExcelGridViewer) ======
                const Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    // child: ExcelGridViewer(),
                    
                  ),
                ),

                // ====== الأزرار السفلية ======
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kCardGreenColor, // لون أخضر مخصص
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          context.read<FileUploadCubit>().pickAndProcessExcelFile();
                        },
                        icon: const Icon(Icons.file_upload, color: Colors.white, size: 20),
                        label: Text(
                          "استيراد الملف",
                          style: AppTextStyles.styleLight12(context, color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}