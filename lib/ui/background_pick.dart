import 'package:reddit_video_maker/src/global_vars.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BackgroundPick extends StatefulWidget {
  const BackgroundPick({super.key});

  @override
  State<BackgroundPick> createState() => _BackgroundPickState();
}

class _BackgroundPickState extends State<BackgroundPick> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  setState(() {
                    appModel.backgroundPath = result.files.single.path;
                  });
                }
              },
              child: const Text(
                "Pick a background video",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const Gap(16),
            Text(
              appModel.backgroundPath?.replaceAll('\\', '/') ??
                  "No background video selected",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
