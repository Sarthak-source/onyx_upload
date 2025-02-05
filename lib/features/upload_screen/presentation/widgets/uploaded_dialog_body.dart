import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_ix_cutsom_grid/onix_grid.dart';
import 'package:onyx_upload/core/responsive/spacer.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';
import 'package:onyx_upload/features/dropdowns/custom_drop_down_with_search_form_builder.dart';
import 'package:onyx_upload/features/others/title_dialog_page.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/message_banner.dart';

class TableReview extends StatelessWidget {
  const TableReview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      builder: (context, state) {
        final mappingData = state.tableData.asMap().entries.map((entry) {
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
            'comments': const OnixGridItem(
              title: '',
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
                    18.0)
        };

        return Column(
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
            MessageBanner(
              message: "Everything seems valid.",
              backgroundColor: kSuccessMColor.shade300,
              textColor: kSuccessMColor.shade500,
            ),
             const HSpacer(10),
            OnixGrid(
              disableActions: false,
              additionalValues: const {'Test': null, 'Test1': 'test'},
              columnWidths: columnWidths,
              bodyConfig: OnixGridBodyConfig(
                alignment: Alignment.center,
                onCellPressed: (value) {},
                onSelected: (value) {},
              ),
              headerConfig: OnixGridHeaderConfig(
                rowColor: kSkyDarkColor,
                textStyle: AppTextStyles.styleRegular14(context,
                    color: Colors.white), // Apply your custom TextStyle here
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
                  context
                      .read<FileUploadCubit>()
                      .stateManager
                      .removeSelectedRows();
                } else {
                  context
                      .read<FileUploadCubit>()
                      .stateManager
                      .saveAndAddNewRow();
                }
              },
              onStateManagerCreated: (stateManager) =>
                  context.read<FileUploadCubit>().stateManager = stateManager,
              headerCells: context.read<FileUploadCubit>().mappingHeaders,
              onRowsRemoved: (indexes, items) {
                print('Removed rows: $indexes');
                print('Removed items: $items');
              },
              bodyCells: mappingData,
              itemsPerPage: 8,
            ),
          ],
        );
      },
    );
  }
}
