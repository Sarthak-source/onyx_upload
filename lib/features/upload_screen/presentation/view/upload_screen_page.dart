import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_state.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/upload_dialog_body.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/uploaded_dialog_body.dart';
import 'package:onyx_upload/features/upload_screen/presentation/widgets/utils.dart';

class FileUploadScreen extends StatelessWidget {
  const FileUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FileUploadCubit, FileUploadState>(
        listener: (context, state) {
          if (state.tableData.isNotEmpty && state.showTable) {
            Utils.customUploadDialog(context, widget: const UploadedDialogBody());
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Utils.customUploadDialog(
                    context,
                    widget: state.tableData.isEmpty || !state.showTable
                        ? const UploadDialogBody()
                        : const UploadedDialogBody(),
                  ),
                  child: const Text("Upload File"),
                ),
              ),
              if (state.isLoading) const CircularProgressIndicator(),
            ],
          );
        },
      ),
    );
  }
}