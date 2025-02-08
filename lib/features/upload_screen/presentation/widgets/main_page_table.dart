import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_ix_cutsom_grid/onix_grid.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/core/style/app_text_styles.dart';

import '../controller/upload_screen_cubit.dart';
import '../controller/upload_screen_state.dart';

class ExcelGridViewer extends StatefulWidget {
  const ExcelGridViewer({super.key});

  @override
  State<ExcelGridViewer> createState() => _ExcelGridViewerState();
}

class _ExcelGridViewerState extends State<ExcelGridViewer> {
  late final OnixGridStateManager stateManager;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      builder: (context, state) {
        final cubit = context.read<FileUploadCubit>();

        log("tableData ${state.tableData.toString()}");

        // Assuming gridData is already defined as in your snippet
        final List<Map<String, OnixGridItem>> gridData =
            state.tableData.map((entry) {
          // Ensure each row matches the number of headers
          Map<String, OnixGridItem> row = {};

          for (int i = 0; i < state.headers.length; i++) {
            log("here be the ${entry[i].toString()}");
            row[state.headers[i]] = OnixGridItem(
              title: entry.length > i ? entry[i].toString() : '',
              value:
                  entry.length > i ? entry[i] : '', // Avoid index out of bounds
            );
          }

          return row;
        }).toList();

        for (final row in gridData) {
          // Create a new map by converting each OnixGridItem to a simpler representation
          final simpleRow = row.map((key, item) => MapEntry(key, item.value));
          log(simpleRow.toString());
        }

        log("generateMainTableHeaders ${cubit.generateMainTableHeaders().length.toString()} ${gridData.length}");

        return Scaffold(
          appBar: AppBar(
            title: const Text("Excel Data Viewer"),
            actions: [
              IconButton(
                icon: const Icon(Icons.upload_file),
                onPressed: () => cubit.pickFile(),
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.headers.isNotEmpty
                  ? state.showTable
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OnixGrid(
                            disableActions: false,
                            columnWidths: {
                              for (int i = 0;
                                  i < cubit.generateMainTableHeaders().length;
                                  i++)
                                i: FixedColumnWidth(cubit
                                        .generateMainTableHeaders()[i]
                                        .title
                                        .length *
                                    20)
                            }, // Adjust column widths as needed
                            bodyConfig: OnixGridBodyConfig(
                              alignment: Alignment.center,
                              textStyle: AppTextStyles.styleRegular14(context,
                                  color: kTextColor),
                            ),
                            headerConfig: OnixGridHeaderConfig(
                              rowColor: kSkyDarkColor,
                              textStyle: AppTextStyles.styleRegular14(context,
                                  color: Colors
                                      .white), // Apply custom TextStyle here
                            ),
                            addNewConfig: OnixGridAddNewConfig(
                              addLabel: 'Add Row',
                              saveLabel: 'Save',
                              canAddNewValidator: () => true,
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
                                debugPrint("New row added");
                              },
                            ),
                            totalItemsLabel: 'Total Rows',
                            cellHeight: 40,
                            enableBorder: true,
                            isRowSelectable: false,
                            isRowDeletable: false,
                            enableIndexed: false,
                            headerCells: cubit.generateMainTableHeaders(),
                            bodyCells: gridData,
                            onOptionSelected: (index) {
                              if (index == 0) {
                                stateManager.removeSelectedRows();
                              } else {
                                stateManager.saveAndAddNewRow();
                              }
                            },

                            itemsPerPage: 5,
                            onStateManagerCreated: (stateManager) =>
                                stateManager = stateManager,
                          ),
                        )
                      : const Center(child: Text("No data loaded"))
                  : const Center(child: Text("No sheet added")),
        );
      },
    );
  }
}
