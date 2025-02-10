import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/features/upload_screen/Others/utils.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/upload_dialog_body.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/uploaded_dialog_body.dart';

class FileUploadScreen extends StatelessWidget {
  const FileUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FileUploadCubit, FileUploadState>(
        listener: (context, state) {
          if (state.tableData.isNotEmpty) {
            Utils.customOpenPopUpDialog(context, widget: const TableReview());
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Utils.customOpenPopUpDialog(
                    context,
                    widget: state.tableData.isEmpty
                        ? const UploadDialogBody()
                        : const TableReview(),
                  ),
                  child: const Text("Upload File"),
                ),
              ),
              if (state.isLoading) const CircularProgressIndicator(),
              // Expanded(child: const ExcelGridViewer()),
            ],
          );
        },
      ),
    );
  }
}
