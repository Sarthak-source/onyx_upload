// // lib/features/upload_screen/presentation/widgets/excel_grid_viewer.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:onyx_ix_cutsom_grid/onix_grid.dart';
// import 'package:onyx_upload/core/style/app_colors.dart';
// import 'package:onyx_upload/core/style/app_text_styles.dart';
// import '../controller/upload_screen_cubit.dart';
// import '../controller/upload_screen_state.dart';

// class ExcelGridViewer extends StatelessWidget {
//   const ExcelGridViewer({super.key, context});

//   static get context => null;

  
// @override
// Widget build(BuildContext context) {
//   late final OnixGridStateManager stateManager;
//   final cubit = context.read<FileUploadCubit>();
//   return BlocBuilder<FileUploadCubit, FileUploadState>(
//     buildWhen: (previous, current) =>
//         previous.headers != current.headers ||
//         previous.tableData != current.tableData,
//     builder: (context, state) {
//       final List<Map<String, OnixGridItem>> gridData =
//           state.tableData.map((entry) {
//         Map<String, OnixGridItem> row = {};

//         // نضمن أن الصف بنفس طول الهيدر
//         final paddedRow = List.generate(
//           state.headers.length,
//           (i) => i < entry.length ? entry[i] : '',
//         );

//         for (int i = 0; i < state.headers.length; i++) {
//           row[state.headers[i]] = OnixGridItem(
//             title: paddedRow[i].toString(),
//             value: paddedRow[i],
//           );
//         }
//         return row;
//       }).toList();

//       if (state.isLoading) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       if (state.headers.isEmpty || state.tableData.isEmpty) {
//         return const Center(
//           child: Text(
//             "لا توجد بيانات لعرضها. يرجى استيراد ملف.",
//             style: TextStyle(color: Colors.grey),
//           ),
//         );
//       }

//       return OnixGrid(
//         disableActions: false,
//         columnWidths: {
//           for (int i = 0; i < cubit.generateMainTableHeaders().length; i++)
//             i: FixedColumnWidth(
//                 cubit.generateMainTableHeaders()[i].title.length * 20)
//         },
//         bodyConfig: OnixGridBodyConfig(
//           alignment: Alignment.center,
//           textStyle: AppTextStyles.styleRegular14(context, color: kTextColor),
//         ),
//         headerConfig: OnixGridHeaderConfig(
//           rowColor: kSkyDarkColor,
//           textStyle:
//               AppTextStyles.styleRegular14(context, color: Colors.white),
//         ),
//         addNewConfig: OnixGridAddNewConfig(
//           addLabel: 'Add Row',
//           saveLabel: 'Save',
//           canAddNewValidator: () => true,
//           validation: (validated, _) {
//             if (!validated) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text(
//                     'Please fill all fields',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   backgroundColor: Colors.red,
//                   behavior: SnackBarBehavior.floating,
//                 ),
//               );
//             }
//           },
//           onAdd: () {
//             debugPrint("New row added");
//           },
//         ),
//         totalItemsLabel: 'Total Rows',
//         cellHeight: 40,
//         enableBorder: true,
//         isRowSelectable: false,
//         isRowDeletable: false,
//         enableIndexed: false,
//         headerCells: cubit.generateMainTableHeaders(),
//         bodyCells: gridData,
//         onOptionSelected: (index) {
//           if (index == 0) {
//             stateManager.removeSelectedRows();
//           } else {
//             stateManager.saveAndAddNewRow();
//           }
//         },
//         itemsPerPage: 5,
//         onStateManagerCreated: (manager) => stateManager = manager,
//       );
//     },
//   );
// }
// }
