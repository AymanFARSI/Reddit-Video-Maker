import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:reddit_video_maker/src/global_vars.dart';
import 'package:reddit_video_maker/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final AudioPlayer _titlePlayer = AudioPlayer();
  final AudioPlayer _textPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    appModel.tiktokSessionID = "cfbf7dccb1f60966cd3a3c0e53d89754";
  }

  @override
  void dispose() {
    _titlePlayer.dispose();
    _textPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Review before rendering",
        ),
        centerTitle: true,
        toolbarHeight: 30,
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100,
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Title",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Spacer(),
                Text(
                  appModel.title!.length > 75
                      ? "${appModel.title?.substring(0, 50)}..."
                      : appModel.title ?? "No title",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                const Text(
                  "TTS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Spacer(),
                ttsPath.isEmpty
                    ? const Text(
                        "No TTS",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _titlePlayer.play(
                                DeviceFileSource("$ttsPath/tiktok_title.mp3"),
                                volume: 0.5,
                              );
                            },
                            child: const Text(
                              "Title",
                            ),
                          ),
                          const Gap(8),
                          ElevatedButton(
                            onPressed: () async {
                              await _textPlayer.play(
                                DeviceFileSource("$ttsPath/tiktok_content.mp3"),
                                volume: 0.5,
                              );
                            },
                            child: const Text(
                              "Content",
                            ),
                          ),
                          const Gap(8),
                          ElevatedButton(
                            onPressed: () async {
                              await _titlePlayer.stop();
                              await _textPlayer.stop();
                            },
                            child: const Text(
                              "Stop",
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            const Gap(16),
            Row(
              children: [
                const Text(
                  "Background",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Spacer(),
                Text(
                  appModel.backgroundPath == null
                      ? "No background"
                      : appModel.backgroundPath!
                          .split(Platform.pathSeparator)
                          .last,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: () => setState(() {}),
              child: const Text("Refresh"),
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  appModel.videoPath = "";
                });
                final videoPath = await renderVideo(context);
                if (videoPath.isNotEmpty) {
                  setState(() {
                    appModel.videoPath = videoPath;
                  });
                }
              },
              child: const Text(
                "Render video",
              ),
            ),
            const Gap(16),
            appModel.videoPath == null
                ? const Expanded(
                    child: Center(
                      child: Text("No video"),
                    ),
                  )
                : appModel.videoPath!.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async => viewVideo(),
                            child: const Text("View video"),
                          ),
                          // const Gap(8),
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     await Clipboard.setData(
                          //       ClipboardData(
                          //         text: File(appModel.videoPath!).parent.path,
                          //       ),
                          //     );
                          //   },
                          //   child: const Text("Copy path"),
                          // ),
                          const Gap(8),
                          ElevatedButton(
                            onPressed: () async {
                              await Process.start(
                                "start",
                                [
                                  "explorer",
                                  File(appModel.videoPath!).parent.path,
                                ],
                                runInShell: true,
                              );
                            },
                            child: const Text("Open location"),
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
