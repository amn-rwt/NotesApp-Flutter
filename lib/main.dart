import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app_bloc/Testing/test_audio_waveforms.dart';
import 'package:notes_app_bloc/model/todo_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: const AudioWaveformTest(),
      debugShowCheckedModeBanner: false,
    );
  }
}
