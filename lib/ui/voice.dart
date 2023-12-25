import 'package:audioplayers/audioplayers.dart';
import 'package:reddit_video_maker/src/enums.dart';
import 'package:reddit_video_maker/src/global_vars.dart';
import 'package:reddit_video_maker/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  TiktokVoices _voice = TiktokVoices.en_us_002;

  final AudioPlayer _titlePlayer = AudioPlayer();
  final AudioPlayer _textPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    appModel.tiktokSessionID = sessionID;
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
          "Voice Over",
        ),
        centerTitle: true,
        toolbarHeight: 30,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 75,
        child: Column(
          children: [
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 125,
                  child: RadioListTile<VoiceType>(
                    dense: true,
                    hoverColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    value: VoiceType.Tiktok,
                    groupValue: VoiceType.Tiktok,
                    onChanged: (VoiceType? value) {
                      // setState(() {});
                    },
                    title: const Text(
                      "Tiktok",
                    ),
                  ),
                ),
              ],
            ),
            const Gap(16),
            SizedBox(
              width: 300,
              child: Visibility(
                visible: true,
                child: TextFormField(
                  initialValue: appModel.tiktokSessionID,
                  onChanged: (String value) {
                    appModel.tiktokSessionID = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(
                      "Tiktok Session ID",
                    ),
                  ),
                ),
              ),
            ),
            const Gap(16),
            DropdownButton<TiktokVoices>(
              borderRadius: BorderRadius.circular(8),
              focusColor: Colors.transparent,
              value: _voice,
              onChanged: (TiktokVoices? newValue) {
                appModel.tiktokVoice = newValue!;
                setState(() {
                  _voice = newValue;
                });
              },
              items: TiktokVoices.values.map((TiktokVoices voice) {
                return DropdownMenuItem<TiktokVoices>(
                  value: voice,
                  child: Text(
                    voice.name,
                  ),
                );
              }).toList(),
            ),
            const Gap(16),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  ttsPath = "generating";
                });
                final path = await generateTts(context);
                setState(() {
                  ttsPath = path;
                });
              },
              child: const Text(
                "Generate",
              ),
            ),
            const Gap(16),
            SizedBox(
              width: 300,
              child: ttsPath == "generating"
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ttsPath.isEmpty
                      ? const Center(
                          child: Text("Generate TTS"),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await _titlePlayer.setSourceDeviceFile(
                                    "$ttsPath/tiktok_title.mp3");
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
                                await _textPlayer.setSourceDeviceFile(
                                    "$ttsPath/tiktok_content.mp3");
                                await _textPlayer.play(
                                  DeviceFileSource(
                                      "$ttsPath/tiktok_content.mp3"),
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
            ),
          ],
        ),
      ),
    );
  }
}
