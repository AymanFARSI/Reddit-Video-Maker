import 'package:reddit_video_maker/src/enums.dart';
import 'package:reddit_video_maker/src/global_vars.dart';
import 'package:reddit_video_maker/ui/scrape_post.dart';
import 'package:reddit_video_maker/ui/scrape_subreddit.dart';
import 'package:flutter/material.dart';

class ScrapePage extends StatefulWidget {
  const ScrapePage({super.key});

  @override
  State<ScrapePage> createState() => _ScrapePageState();
}

class _ScrapePageState extends State<ScrapePage> with TickerProviderStateMixin {
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
            appModel.scrapeType =
                index == 0 ? ScrapeType.Subreddit : ScrapeType.PostID;
          },
          tabs: const <Widget>[
            Tab(
              icon: Icon(
                Icons.reddit_rounded,
              ),
              text: 'Subreddit',
            ),
            Tab(
              icon: Icon(
                Icons.post_add_rounded,
              ),
              text: 'Post ID',
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
            ScrapeSubredditPage(),
            ScrapePostPage(),
          ],
        ),
      ),
    );
  }
}
