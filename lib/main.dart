import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onyx_upload/features/upload_screen/presentation/controller/upload_screen_cubit.dart';
import 'package:onyx_upload/features/upload_screen/presentation/view/upload_screen_page.dart';

void main() {
  runApp(
    const FileUploaderApp(),
  );
}

class FileUploaderApp extends StatelessWidget {
  const FileUploaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Providing the FileUploadCubit using BlocProvider
        BlocProvider<FileUploadCubit>(
          create: (context) => FileUploadCubit(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FileUploadScreen(),
      ),
    );
  }
}
