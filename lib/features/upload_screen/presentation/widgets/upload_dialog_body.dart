import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart'; // Import your AppTextStyles class
import 'package:onyx_upload/features/buttons/custom_text_icon_button.dart';
import 'package:onyx_upload/features/dropdowns/custom_drop_down_with_search_form_builder.dart';
import 'package:onyx_upload/features/others/title_dialog_page.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';

class UploadDialogBody extends StatelessWidget {
  const UploadDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadCubit, FileUploadState>(
        builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TitleDialogPage(
            title: 'Upload',
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: backgroundLightBlue,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: lightBlue, // Choose your desired border color
                width: 1.0, // Set the thickness of the border
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload, size: 50, color: azureColor),
                const SizedBox(height: 8),
                Text(
                  "Please choose the Excel sheet or CSV file to upload",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.styleRegular14(context,
                      color: Colors.black87), // Use styleRegular14
                ),
                const SizedBox(height: 12),
                CustomTextIconButton(
                  onPressed: () {
                    context.read<FileUploadCubit>().pickFile();
                  },
                  title: "Upload File",
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Choose a template to download",
              style: AppTextStyles.styleMedium18(context,
                  color: kTextColor), // Use styleBold20
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomDropDownWithSearchBuilder(
                  fldNm: "templateDropdown", // Field name
                  hint: "Choose Template*", // Hint text
                  list: const ["Template 1", "Template 2"], // List of items
                  isRequired: true, // Required field
                  onChanged: (value) {
                    // Handle the value change
                    log("Selected Template: $value");
                  },
                ),
              ),
              const SizedBox(width: 12),
              CustomTextIconButton(
                onPressed: () {},
                title: "Download Template",
                icon: Icons.downloading_rounded,
                iconColor: Colors.white,
                bgColor: Colors.green,
                txtColor: Colors.white,
                iconSize: 24,
                height: 35,
              ),
            ],
          ),
        ],
      );
    });
  }
}
