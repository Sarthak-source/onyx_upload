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
    return BlocBuilder<FileUploadCubit, FileUploadState>(
      buildWhen: (previous, current) =>
          previous.headers != current.headers ||
          previous.tableData != current.tableData ||
          previous.hasDataError != current.hasDataError ||
          previous.plutoColumns != current.plutoColumns ||
          previous.plutoRows != current.plutoRows,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.hasDataError) {
          return _buildErrorState(context, state);
        }

        if (state.headers.isEmpty || state.tableData.isEmpty) {
          return _buildEmptyState();
        }

        if (state.plutoColumns.isEmpty || state.plutoRows.isEmpty) {
          return _buildProcessingState();
        }

        return _buildPlutoGrid(state);
      },
    );
  }

  Widget _buildErrorState(BuildContext context, FileUploadState state) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              "خطأ في البيانات",
              style: AppTextStyles.styleMedium18(context, color: Colors.red),
            ),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? "حدث خطأ في معالجة البيانات",
              textAlign: TextAlign.center,
              style: AppTextStyles.styleRegular14(context, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.read<FileUploadCubit>().pickAndProcessExcelFile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                "إعادة المحاولة",
                style: AppTextStyles.styleLight14(context, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "لا توجد بيانات لعرضها",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            "يرجى استيراد ملف Excel أو CSV",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            "جاري معالجة البيانات...",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPlutoGrid(FileUploadState state) {
    return Column(
      children: [
        // معلومات عن البيانات
        Container(
          padding: const EdgeInsets.all(8),
          color: kSkyDarkColor.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: kSkyDarkColor),
              const SizedBox(width: 8),
              Text(
                "عرض ${state.plutoRows.length} صفًا و ${state.plutoColumns.length} عمودًا",
                style: TextStyle(color: kSkyDarkColor, fontSize: 12),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: PlutoGrid(
            mode: PlutoGridMode.readOnly,
            columns: state.plutoColumns,
            rows: state.plutoRows,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManagers.add(event.stateManager);
            },
            configuration: PlutoGridConfiguration(
              localeText: const PlutoGridLocaleText.arabic(),
              style: PlutoGridStyleConfig(
                cellTextStyle: AppTextStyles.styleRegular14(context, color: kTextColor),
                columnTextStyle: AppTextStyles.styleRegular14(context, color: kTextColor),
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
          ),
        ),
      ],
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