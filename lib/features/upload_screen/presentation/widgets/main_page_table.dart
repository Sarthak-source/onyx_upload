import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';
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
  final List<PlutoGridStateManager> stateManagers = [];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FileUploadCubit>();
    
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      buildWhen: (previous, current) =>
          previous.headers != current.headers ||
          previous.tableData != current.tableData,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.headers.isEmpty || state.tableData.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد بيانات لعرضها. يرجى استيراد ملف.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // تحويل البيانات إلى تنسيق Pluto Grid
        final List<PlutoColumn> columns = state.headers.map((header) {
          return PlutoColumn(
            title: header,
            field: header,
            type: PlutoColumnType.text(),
            enableSorting: true,
            enableEditingMode: false,
            width: header.length * 10.0 + 50, // حساب عرض العمود بناءً على طول النص
            textAlign: PlutoColumnTextAlign.center,
          );
        }).toList();

        final List<PlutoRow> rows = state.tableData.map((rowData) {
          final cells = <String, PlutoCell>{};
          
          for (int i = 0; i < state.headers.length; i++) {
            final value = i < rowData.length ? rowData[i].toString() : '';
            cells[state.headers[i]] = PlutoCell(value: value);
          }
          
          return PlutoRow(cells: cells);
        }).toList();

        return PlutoGrid(
          mode: PlutoGridMode.readOnly,
          columns: columns,
          rows: rows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManagers.add(event.stateManager);
          },
          configuration: PlutoGridConfiguration(
            localeText: const PlutoGridLocaleText.arabic(),
            style: PlutoGridStyleConfig(
              cellTextStyle: AppTextStyles.styleRegular14(context, color: kTextColor),
              columnTextStyle: AppTextStyles.styleRegular14(context, color: Colors.white),
              gridBackgroundColor: Colors.transparent,
              cellColorInEditState: Colors.transparent,
              activatedColor: Colors.transparent,
              activatedBorderColor: kSkyDarkColor,
              inactivatedBorderColor: Colors.grey.shade300,
              gridBorderColor: Colors.grey.shade300,
              columnHeight: 40,
              rowHeight: 40,
              columnFilterHeight: 40,
            ),
            columnSize: PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (final stateManager in stateManagers) {
      stateManager.dispose();
    }
    super.dispose();
  }
}