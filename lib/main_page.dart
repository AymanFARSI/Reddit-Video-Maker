import 'package:reddit_video_maker/ui/background.dart';
import 'package:reddit_video_maker/ui/review.dart';
import 'package:reddit_video_maker/ui/scrape.dart';
import 'package:reddit_video_maker/ui/voice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:window_manager/window_manager.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;
  bool _isOnTop = false;

  void _nextPage() {
    setState(() {
      _pageIndex++;
    });
    // debugPrint(appModel.toString());
  }

  void _prevPage() {
    setState(() {
      _pageIndex--;
    });
  }

  void toggleAlwaysOnTop() async {
    setState(() {
      _isOnTop = !_isOnTop;
      windowManager.setAlwaysOnTop(_isOnTop);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            IndexedStack(
              index: _pageIndex,
              children: const [
                ScrapePage(),
                VoicePage(),
                BackgroundPage(),
                ReviewPage(),
              ],
            ),
            Visibility(
              visible: _pageIndex != 0,
              child: Positioned(
                bottom: 0,
                left: 0,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: _pageIndex == 0 ? null : _prevPage,
                  child: const Text("Back"),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: _pageIndex == 3
                    ? () async {
                        await showAdaptiveDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                "Are you sure you want to close the app?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(ctx).pop();
                                    // final killed =
                                    //     apiProcess!.kill(ProcessSignal.sigterm);
                                    // if (killed) {
                                    //   await windowManager.close();
                                    // } else {
                                    //   showSnackBar(
                                    //       context, "Error closing API server!");
                                    // }
                                    await windowManager.close();
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : _nextPage,
                style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Text(
                  _pageIndex == 3 ? "Close" : "Next",
                ),
              ),
            ),
            Positioned(
              top: -10,
              left: -10,
              child: IconButton(
                onPressed: toggleAlwaysOnTop,
                style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                ),
                icon: Icon(
                  _isOnTop ? Icons.circle : Icons.circle_outlined,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: SizedBox(
                width: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: _pageIndex == 0
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (_pageIndex == 0) {
                            return;
                          }
                          setState(() {
                            _pageIndex = 0;
                          });
                        },
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _pageIndex == 0
                                ? Colors.deepPurple
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                    MouseRegion(
                      cursor: _pageIndex == 1
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (_pageIndex == 1) {
                            return;
                          }
                          setState(() {
                            _pageIndex = 1;
                          });
                        },
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _pageIndex == 1
                                ? Colors.deepPurple
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                    MouseRegion(
                      cursor: _pageIndex == 2
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (_pageIndex == 2) {
                            return;
                          }
                          setState(() {
                            _pageIndex = 2;
                          });
                        },
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _pageIndex == 2
                                ? Colors.deepPurple
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                    MouseRegion(
                      cursor: _pageIndex == 3
                          ? SystemMouseCursors.basic
                          : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (_pageIndex == 3) {
                            return;
                          }
                          setState(() {
                            _pageIndex = 3;
                          });
                        },
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _pageIndex == 3
                                ? Colors.deepPurple
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
