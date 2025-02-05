import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_ix_cutsom_grid/onix_grid.dart';
import 'package:onyx_upload/core/style/app_colors.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final OnixGridStateManager _stateManager;

  @override
  Widget build(BuildContext context) {
    // Define headers for the mapping table


    // Define the data rows for the mapping table.

    return BlocBuilder<FileUploadCubit, FileUploadState>(
        builder: (context, state) {
      return BlocBuilder<FileUploadCubit, FileUploadState>(
          builder: (context, state) {
        state.tableData[0].forEach((toElement) {
          log(toElement.toString());
        });

        state.headers.forEach((toElement) {
          log(toElement.toString());
        });

        final mappingData = state.tableData.asMap().entries.map((entry) {
          int index = entry.key;
          var row = entry.value;

          return {
            'fileColumn': OnixGridItem(
              title: state.headers[
                  index], // Assuming first column in tableData represents file column
              value: 'fileColumn',
            ),
            'dbColumn': OnixGridItem(
              title: row[index]
                  .toString(), // Assuming headers list has corresponding column names
              value: 'dbColumn',
            ),
            'comments': const OnixGridItem(
              title: '', // Add dynamic or fixed comments if needed
              value: '',
            ),
          };
        }).toList();

        // Calculate column widths based on header titles (or define a fixed width)
        final columnWidths = {
          for (int i = 0; i < context.read<FileUploadCubit>().mappingHeaders.length; i++)
            i: FixedColumnWidth(context.read<FileUploadCubit>().mappingHeaders[i].title.length * 12.0)
        };

        return Center(
          child: SizedBox(
            height: 500,
            child: OnixGrid(
              disableActions: false,
              additionalValues: const {'Test': null, 'Test1': 'test'},
              columnWidths: columnWidths,
              bodyConfig: OnixGridBodyConfig(
                alignment: Alignment.center,
                onCellPressed: (value) {
                  // Handle cell tap if needed.
                },
                onSelected: (value) {
                  // Handle cell selection.
                },
              ),
              footerConfig: const OnixGridFooterConfig(),
              headerConfig: const OnixGridHeaderConfig(
                rowColor: kSkyDarkColor,
                textStyle: TextStyle(color: Colors.white),
              ),
              addNewConfig: OnixGridAddNewConfig(
                addLabel: 'Add Mapping',
                saveLabel: 'Save Mapping',
                saveAndAddLabel: 'Save & Add',
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
                  _stateManager.removeSelectedRows();
                } else {
                  _stateManager.saveAndAddNewRow();
                }
              },
              onStateManagerCreated: (stateManager) =>
                  _stateManager = stateManager,
              headerCells: context.read<FileUploadCubit>().mappingHeaders,
              onRowsRemoved: (indexes, items) {
                print('Removed rows: $indexes');
                print('Removed items: $items');
              },
              bodyCells: mappingData,
              itemsPerPage: 10,
            ),
          ),
        );
      });
    });
  }
}



