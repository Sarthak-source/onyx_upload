// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:onyx_ix_cutsom_grid/onix_grid.dart';
// import 'package:onyx_upload/core/responsive/spacer.dart';
// import 'package:onyx_upload/core/style/app_colors.dart';
// import 'package:onyx_upload/core/style/app_text_styles.dart';
// import 'package:onyx_upload/core/buttons/custom_text_icon_button.dart';
// import 'package:onyx_upload/core/dropdowns/custom_drop_down_with_search_form_builder.dart';
// import 'package:onyx_upload/core/utils/others/title_dialog_page.dart';
// import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
// import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';
// import 'package:onyx_upload/features/upload_screen/presentation/widgets/message_banner.dart';

// // Function to apply style based on data (missing data will be yellow)

// class TableReview extends StatefulWidget {
//   const TableReview({super.key});

//   @override
//   State<TableReview> createState() => _TableReviewState();
// }

// class _TableReviewState extends State<TableReview> {
//   late final OnixGridStateManager stateManager;
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FileUploadCubit, FileUploadState>(
//       builder: (context, state) {
//         final List<Map<String, OnixGridItem>> gridData =
//             state.tableData.asMap().entries.map((entry) {
//           int index = entry.key;
//           var row = entry.value;

//           return {
//             'fileColumn': OnixGridItem(
//               title: state.headers[index],
//               value: 'fileColumn',
//             ),
//             'dbColumn': OnixGridItem(
//               title: row[index].toString(),
//               value: 'dbColumn',
//             ),
//             'comments': OnixGridItem(
//               title: row[index].toString() == '' ? 'Missing Data' : '',
//               value: '',
//             ),
//           };
//         }).toList();

//         final columnWidths = {
//           for (int i = 0;
//               i < context.read<FileUploadCubit>().mappingHeaders.length;
//               i++)
//             i: FixedColumnWidth(
//                 context.read<FileUploadCubit>().mappingHeaders[i].title.length *
//                     20)
//         };

//         bool cleanAndCheckEmptyCells = context
//             .read<FileUploadCubit>()
//             .cleanAndCheckEmptyCells(state.tableData);

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             const TitleDialogPage(
//               title: 'Upload',
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Current Template'),
//                 SizedBox(
//                   width: 200,
//                   child: CustomDropDownWithSearchBuilder(
//                     fldNm: "templateDropdown",
//                     hint: "Choose Template*",
//                     list: const ["Template 1", "Template 2"],
//                     isRequired: true,
//                     onChanged: (value) {
//                       log("Selected Template: $value");
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const HSpacer(10),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF2F2F2), // Light gray background
//                 borderRadius:
//                     BorderRadius.circular(4), // Optional rounded corners
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Checkbox(
//                     value: false, // Change this dynamically
//                     onChanged: (bool? value) {
//                       // Handle checkbox state change
//                     },
//                   ),
//                   Text(
//                     "Make the first row in the file the address",
//                     style: AppTextStyles.styleRegular14(context),
//                   ),
//                 ],
//               ),
//             ),
//             const HSpacer(10),
//             state.showMessage
//                 ? MessageBanner(
//                     message: cleanAndCheckEmptyCells
//                         ? "Warning! Data Missing in line (1)."
//                         : "Everything seems valid.",
//                     backgroundColor: cleanAndCheckEmptyCells
//                         ? kWarningMColor.shade300
//                         : kSuccessMColor.shade300,
//                     textColor: cleanAndCheckEmptyCells
//                         ? kWarningMColor.shade500
//                         : kSuccessMColor.shade500,
//                   )
//                 : const SizedBox.shrink(),
//             const HSpacer(10),
//             Expanded(
//               child: OnixGrid(
//                 disableActions: false,
//                 additionalValues: const {'Test': null, 'Test1': 'test'},
//                 columnWidths: columnWidths,
//                 bodyConfig: OnixGridBodyConfig(
//                   alignment: Alignment.center,
//                   onCellPressed: (value) {},
//                   onSelected: (value) {},
//                   textStyle: context.read<FileUploadCubit>().getCellTextStyle()
//                       ? AppTextStyles.styleRegular14(context,
//                           color: kWarningMColor.shade500)
//                       : AppTextStyles.styleRegular14(context,
//                           color: kTextColor),
//                 ),
//                 headerConfig: OnixGridHeaderConfig(
//                   rowColor: kSkyDarkColor,
//                   textStyle: AppTextStyles.styleRegular14(context,
//                       color: Colors.white), // Apply custom TextStyle here
//                 ),
//                 addNewConfig: OnixGridAddNewConfig(
//                   addLabel: 'Add Mapping',
//                   saveLabel: 'Save Mapping',
//                   saveAndAddLabel: 'Save & Add',
//                   canAddNewValidator: () => false,
//                   validation: (validated, _) {
//                     if (!validated) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                             'Please fill all fields',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           backgroundColor: Colors.red,
//                           behavior: SnackBarBehavior.floating,
//                         ),
//                       );
//                     }
//                   },
//                   onAdd: () {
//                     print("onAddNew() method called");
//                   },
//                 ),
//                 totalItemsLabel: 'Total Mappings',
//                 cellHeight: 40,
//                 enableBorder: true,
//                 isRowSelectable: false,
//                 isRowDeletable: false,
//                 enableIndexed: false,
//                 moreOptions: const ['Delete Selected', 'Add New Row'],
//                 onOptionSelected: (index) {
//                   if (index == 0) {
//                     stateManager.removeSelectedRows();
//                   } else {
//                     stateManager.saveAndAddNewRow();
//                   }
//                 },
//                 onStateManagerCreated: (stateManager) =>
//                     stateManager = stateManager,
//                 headerCells: context.read<FileUploadCubit>().mappingHeaders,
//                 onRowsRemoved: (indexes, items) {
//                   print('Removed rows: $indexes');
//                   print('Removed items: $items');
//                 },
//                 bodyCells: gridData,
//                 itemsPerPage: state.headers.length + 1,
//               ),
//             ),
//             const HSpacer(20),
//             state.showMessage
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       CustomTextIconButton(
//                         onPressed: () {
//                           context.read<FileUploadCubit>().showTable();
//                           Navigator.pop(context);
//                         },
//                         title: "Upload",
//                         icon: Icons.upload_file,
//                         iconColor: Colors.white,
//                         bgColor: kCardGreenColor,
//                         txtColor: Colors.white,
//                         iconSize: 24,
//                         height: 35,
//                       ),
//                       const SizedBox(width: 8), // Space between buttons
//                       CustomTextIconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         title: "Cancel",
//                         icon: Icons.close,
//                         iconColor: Colors.white,
//                         bgColor: kTextFieldColor,
//                         txtColor: Colors.white,
//                         iconSize: 24,
//                         height: 35,
//                       ),
//                     ],
//                   )
//                 : Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CustomTextIconButton(
//                         onPressed: () {
//                           //context.read<FileUploadCubit>().showBanner();
//                           Navigator.pop(context);
//                         },
//                         title: "Upload another File",
//                         //icon: Icons.upload_file,
//                         iconColor: Colors.white,
//                         bgColor: kCardGreenColor,
//                         txtColor: Colors.white,
//                         iconSize: 0,
//                         height: 35,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           CustomTextIconButton(
//                             onPressed: () {
//                               context.read<FileUploadCubit>().showBanner();
//                               //Navigator.pop(context);
//                             },
//                             title: "Test Data",
//                             icon: Icons.check, // You can change this if needed
//                             iconColor: Colors.white,
//                             bgColor: kSkyDarkColor,
//                             txtColor: Colors.white,
//                             iconSize: 24,
//                             height: 35,
//                           ),
//                           const SizedBox(width: 8), // Spacing between buttons
//                           CustomTextIconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             title: "Cancel",
//                             icon: Icons.close,
//                             iconColor: Colors.white,
//                             bgColor: kTextFieldColor,
//                             txtColor: Colors.white,
//                             iconSize: 24,
//                             height: 35,
//                           ),
//                         ],
//                       ),
//                     ],
//                   )
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/core/responsive/spacer.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';
import 'package:onyx_upload/core/buttons/custom_text_icon_button.dart';
import 'package:onyx_upload/core/dropdowns/custom_drop_down_with_search_form_builder.dart';
import 'package:onyx_upload/core/utils/others/title_dialog_page.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/message_banner.dart';

class TableReview extends StatefulWidget {
  const TableReview({Key? key}) : super(key: key);

  @override
  State<TableReview> createState() => _TableReviewState();
}

class _TableReviewState extends State<TableReview> {
  // Local state for the checkbox.
  bool _makeFirstRowAddress = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      builder: (context, state) {
        // Build grid data. In this example each row represents a mapping between
        // a file column and a DB column. If the cell value is empty, a "Missing Data"
        // comment is shown.
        final List<Map<String, String>> gridData =
            state.tableData.asMap().entries.map((entry) {
          final int index = entry.key;
          final row = entry.value;
          return {
            'fileColumn': state.headers[index],
            'dbColumn': row[index].toString(),
            'comments': row[index].toString().isEmpty ? 'Missing Data' : '',
          };
        }).toList();

        // Retrieve mapping headers from the cubit.
        // (Assuming mappingHeaders is a list with at least three items.)
        final mappingHeaders = context.read<FileUploadCubit>().mappingHeaders;
        // Mimic the column width calculation (here, width is based on the header title length)
        final List<double> columnWidths = mappingHeaders
            .map<double>((header) => header.title.length * 18.0)
            .toList();

        // Determine the cell text style based on your cubit's logic.
        final TextStyle cellTextStyle =
            context.read<FileUploadCubit>().getCellTextStyle()
                ? AppTextStyles.styleRegular14(context,
                    color: kWarningMColor.shade500)
                : AppTextStyles.styleRegular14(context, color: kTextColor);

        final bool cleanAndCheckEmptyCells = context
            .read<FileUploadCubit>()
            .cleanAndCheckEmptyCells(state.tableData);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const TitleDialogPage(title: 'Upload'),
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
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _makeFirstRowAddress,
                    onChanged: (bool? value) {
                      setState(() {
                        _makeFirstRowAddress = value ?? false;
                      });
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
            // Message banner (shows warning if data is missing)
            state.showMessage
                ? MessageBanner(
                    message: cleanAndCheckEmptyCells
                        ? "Warning! Data Missing in line (1)."
                        : "Everything seems valid.",
                    backgroundColor: cleanAndCheckEmptyCells
                        ? kWarningMColor.shade300
                        : kSuccessMColor.shade300,
                    textColor: cleanAndCheckEmptyCells
                        ? kWarningMColor.shade500
                        : kSuccessMColor.shade500,
                  )
                : const SizedBox.shrink(),
            const HSpacer(10),
            // Wrap the DataTable in scroll views to allow for both vertical and horizontal scrolling.
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    // Set header background color and text style.
                    headingRowColor: WidgetStateProperty.all(kSkyDarkColor),
                    headingRowHeight: 40,
                    headingTextStyle: AppTextStyles.styleRegular14(context,
                        color: Colors.white),
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: 55,
                    columnSpacing: 0,
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width:
                              columnWidths.isNotEmpty ? columnWidths[0] : null,
                          child: const Text("File Column"),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width:
                              columnWidths.length > 1 ? columnWidths[1] : null,
                          child: const Text("DB Column"),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width:
                              columnWidths.length > 2 ? columnWidths[2] : null,
                          child: const Text("Comments"),
                        ),
                      ),
                    ],
                    rows: gridData.map((row) {
                      return DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: columnWidths.isNotEmpty
                                  ? columnWidths[0]
                                  : null,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(row['fileColumn'] ?? '',
                                      style: cellTextStyle.copyWith(
                                          fontSize: 12, color: kTextColor)),
                                  Text(
                                    row['dbColumn'] ?? '',
                                    style: cellTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              // Add cell tap functionality if needed.
                            },
                          ),
                          DataCell(
                            SizedBox(
                              width: columnWidths.length > 1
                                  ? columnWidths[1]
                                  : null,
                              child: CustomDropDownWithSearchBuilder(
                                fldNm: "dbColumn",
                                hint: row['fileColumn'] ?? '',
                                labelText: row['fileColumn'] ?? '',
                                list: const ["Template 1", "Template 2"],
                                isRequired: false,
                                onChanged: (value) {
                                  log("Selected Template: $value");
                                },
                              ),
                            ),
                            onTap: () {},
                          ),
                          DataCell(
                            SizedBox(
                              width: columnWidths.length > 2
                                  ? columnWidths[2]
                                  : null,
                              child: Text(row['comments'] ?? '',
                                  style: cellTextStyle),
                            ),
                            onTap: () {},
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const HSpacer(20),
            // Bottom buttons – show different button sets based on state.showMessage
            state.showMessage
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomTextIconButton(
                        onPressed: () {
                          context.read<FileUploadCubit>().showTable();
                          Navigator.pop(context);
                        },
                        title: "Upload",
                        icon: Icons.upload_file,
                        iconColor: Colors.white,
                        bgColor: kCardGreenColor,
                        txtColor: Colors.white,
                        iconSize: 24,
                        height: 35,
                      ),
                      const SizedBox(width: 8),
                      CustomTextIconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                          Navigator.pop(context);
                        },
                        title: "Upload another File",
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
                            icon: Icons.check,
                            iconColor: Colors.white,
                            bgColor: kSkyDarkColor,
                            txtColor: Colors.white,
                            iconSize: 24,
                            height: 35,
                          ),
                          const SizedBox(width: 8),
                          CustomTextIconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
                  ),
          ],
        );
      },
    );
  }
}
