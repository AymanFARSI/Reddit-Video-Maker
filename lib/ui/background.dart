import 'package:reddit_video_maker/src/enums.dart';
import 'package:reddit_video_maker/src/global_vars.dart';
import 'package:reddit_video_maker/ui/background_pick.dart';
import 'package:reddit_video_maker/ui/background_select.dart';
import 'package:flutter/material.dart';

class BackgroundPage extends StatefulWidget {
  const BackgroundPage({super.key});

  @override
  State<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scrape Reddit",
        ),
        centerTitle: true,
        toolbarHeight: 30,
        bottom: TabBar(
          dividerColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
            insets: EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          controller: _tabController,
          onTap: (int index) {
            appModel.backgroundType =
                index == 0 ? BackgroundType.Pick : BackgroundType.Select;
          },
          tabs: const <Widget>[
            Tab(
              icon: Icon(
                Icons.file_open_rounded,
              ),
              text: 'Pick',
            ),
            Tab(
              icon: Icon(
                Icons.select_all_rounded,
              ),
              text: 'Select',
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 180,
        child: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            BackgroundPick(),
            BackgroundSelect(),
          ],
        ),
      ),
    );
  }
}
