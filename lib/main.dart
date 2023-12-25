import 'dart:io';

import 'package:reddit_video_maker/main_page.dart';
import 'package:reddit_video_maker/src/global_vars.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow(
    const WindowOptions(
      size: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      windowButtonVisibility: false,
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  final Directory directory = await getApplicationDocumentsDirectory();
  String wss = "${directory.path}/wss";
  try {
    apiProcess = await Process.start(
      "start",
      [
        "cmd",
        "/C",
        "python",
        "$wss/api.py",
      ],
      workingDirectory: Directory(wss).path,
      runInShell: true,
    );
  } catch (e) {
    exit(1);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C Maker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: const MainPage(),
    );
  }
}
