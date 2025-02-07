import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_ix_cutsom_grid/onix_grid.dart';
import 'package:onyx_upload/core/responsive/spacer.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';
import 'package:onyx_upload/features/buttons/custom_text_icon_button.dart';
import 'package:onyx_upload/features/dropdowns/custom_drop_down_with_search_form_builder.dart';
import 'package:onyx_upload/features/others/title_dialog_page.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/message_banner.dart';

// Function to apply style based on data (missing data will be yellow)

class TableReview extends StatefulWidget {
  const TableReview({super.key});

  @override
  State<TableReview> createState() => _TableReviewState();
}

class _TableReviewState extends State<TableReview> {
  late final OnixGridStateManager stateManager;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      builder: (context, state) {
        final List<Map<String, OnixGridItem>> gridData =
            state.tableData.asMap().entries.map((entry) {
          int index = entry.key;
          var row = entry.value;

          return {
            'fileColumn': OnixGridItem(
              title: state.headers[index],
              value: 'fileColumn',
            ),
            'dbColumn': OnixGridItem(
              title: row[index].toString(),
              value: 'dbColumn',
            ),
            'comments': OnixGridItem(
              title: row[index].toString() == '' ? 'Missing Data' : '',
              value: '',
            ),
          };
        }).toList();

        final columnWidths = {
          for (int i = 0;
              i < context.read<FileUploadCubit>().mappingHeaders.length;
              i++)
            i: FixedColumnWidth(
                context.read<FileUploadCubit>().mappingHeaders[i].title.length *
                    20)
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TitleDialogPage(
              title: 'Upload',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current Template'),
                SizedBox(
                  width: 200,
                  child: CustomDropDownWithSearchBuilder(
                    fldNm: "templateDropdown",
                    hint: "Choose Template*",
                    list: const ["Template 1", "Template 2"],
                    isRequired: true,
                    onChanged: (value) {
                      log("Selected Template: $value");
                    },
                  ),
                ),
              ],
            ),
            const HSpacer(10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2), // Light gray background
                borderRadius:
                    BorderRadius.circular(4), // Optional rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: false, // Change this dynamically
                    onChanged: (bool? value) {
                      // Handle checkbox state change
                    },
                  ),
                  Text(
                    "Make the first row in the file the address",
                    style: AppTextStyles.styleRegular14(context),
                  ),
                ],
              ),
            ),
            const HSpacer(10),
            state.showMessage
                ? MessageBanner(
                    message: context.read<FileUploadCubit>().getCellTextStyle()
                        ? "Warning! Data Missing in line (1)."
                        : "Everything seems valid.",
                    backgroundColor:
                        context.read<FileUploadCubit>().getCellTextStyle()
                            ? kWarningMColor.shade300
                            : kSuccessMColor.shade300,
                    textColor:
                        context.read<FileUploadCubit>().getCellTextStyle()
                            ? kWarningMColor.shade500
                            : kSuccessMColor.shade500,
                  )
                : const SizedBox.shrink(),
            const HSpacer(10),
            OnixGrid(
              disableActions: false,
              additionalValues: const {'Test': null, 'Test1': 'test'},
              columnWidths: columnWidths,
              bodyConfig: OnixGridBodyConfig(
                alignment: Alignment.center,
                onCellPressed: (value) {},
                onSelected: (value) {},
                textStyle: context.read<FileUploadCubit>().getCellTextStyle()
                    ? AppTextStyles.styleRegular14(context,
                        color: kWarningMColor.shade500)
                    : AppTextStyles.styleRegular14(context, color: kTextColor),
              ),
              headerConfig: OnixGridHeaderConfig(
                rowColor: kSkyDarkColor,
                textStyle: AppTextStyles.styleRegular14(context,
                    color: Colors.white), // Apply custom TextStyle here
              ),
              addNewConfig: OnixGridAddNewConfig(
                addLabel: 'Add Mapping',
                saveLabel: 'Save Mapping',
                saveAndAddLabel: 'Save & Add',
                canAddNewValidator: () => false,
                validation: (validated, _) {
                  if (!validated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill all fields',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                onAdd: () {
                  print("onAddNew() method called");
                },
              ),
              totalItemsLabel: 'Total Mappings',
              cellHeight: 40,
              enableBorder: true,
              isRowSelectable: false,
              isRowDeletable: false,
              enableIndexed: false,
              moreOptions: const ['Delete Selected', 'Add New Row'],
              onOptionSelected: (index) {
                if (index == 0) {
                  stateManager.removeSelectedRows();
                } else {
                  stateManager.saveAndAddNewRow();
                }
              },
              onStateManagerCreated: (stateManager) =>
                  stateManager = stateManager,
              headerCells: context.read<FileUploadCubit>().mappingHeaders,
              onRowsRemoved: (indexes, items) {
                print('Removed rows: $indexes');
                print('Removed items: $items');
              },
              bodyCells: gridData,
              itemsPerPage: state.headers.length + 1,
            ),
            const HSpacer(20),
            state.showMessage
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomTextIconButton(
                        onPressed: () {
                          context.read<FileUploadCubit>().showBanner();
                        },
                        title: "Upload",
                        //icon: Icons.upload_file,
                        iconColor: Colors.white,
                        bgColor: kCardGreenColor,
                        txtColor: Colors.white,
                        iconSize: 24,
                        height: 35,
                      ),
                      const SizedBox(width: 8), // Space between buttons
                      CustomTextIconButton(
                        onPressed: () {},
                        title: "Cancel",
                        icon: Icons.close,
                        iconColor: Colors.white,
                        bgColor: kTextFieldColor,
                        txtColor: Colors.white,
                        iconSize: 24,
                        height: 35,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextIconButton(
                        onPressed: () {
                          context.read<FileUploadCubit>().showBanner();
                        },
                        title: "Upload another File",
                        //icon: Icons.upload_file,
                        iconColor: Colors.white,
                        bgColor: kCardGreenColor,
                        txtColor: Colors.white,
                        iconSize: 0,
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomTextIconButton(
                            onPressed: () {
                              context.read<FileUploadCubit>().showBanner();
                            },
                            title: "Test Data",
                            icon: Icons.check, // You can change this if needed
                            iconColor: Colors.white,
                            bgColor: kSkyDarkColor,
                            txtColor: Colors.white,
                            iconSize: 24,
                            height: 35,
                          ),
                          const SizedBox(width: 8), // Spacing between buttons
                          CustomTextIconButton(
                            onPressed: () {},
                            title: "Cancel",
                            icon: Icons.close,
                            iconColor: Colors.white,
                            bgColor: kTextFieldColor,
                            txtColor: Colors.white,
                            iconSize: 24,
                            height: 35,
                          ),
                        ],
                      ),
                    ],
                  )
          ],
        );
      },
    );
  }
}
