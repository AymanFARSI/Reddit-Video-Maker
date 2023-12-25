import 'package:reddit_video_maker/src/enums.dart';
import 'package:reddit_video_maker/src/global_vars.dart';
import 'package:reddit_video_maker/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class ScrapeSubredditPage extends StatefulWidget {
  const ScrapeSubredditPage({super.key});

  @override
  State<ScrapeSubredditPage> createState() => _ScrapeSubredditPageState();
}

class _ScrapeSubredditPageState extends State<ScrapeSubredditPage> {
  SubredditSort _sort = SubredditSort.Hot;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: TextFormField(
                    initialValue: appModel.subreddits,
                    onChanged: (String value) {
                      appModel.subreddits = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                        "Subreddits",
                      ),
                      hintText: "Enter subreddit(s) separated by +",
                    ),
                  ),
                ),
                const Spacer(),
                DropdownButton<SubredditSort>(
                  borderRadius: BorderRadius.circular(8),
                  focusColor: Colors.transparent,
                  value: _sort,
                  onChanged: (SubredditSort? newValue) {
                    appModel.sort = newValue;
                    setState(() {
                      _sort = newValue!;
                    });
                  },
                  items: SubredditSort.values.map((SubredditSort sort) {
                    return DropdownMenuItem<SubredditSort>(
                      value: sort,
                      child: Text(
                        sort.name,
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: TextFormField(
                    initialValue: appModel.limit?.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (String value) {
                      if (value.isEmpty) {
                        appModel.limit = null;
                      } else {
                        appModel.limit = int.parse(value);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter limit",
                      label: Text(
                        "Limit",
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final results = await scrapeReddit(context);
                    setState(() {
                      scrapeResults.clear();
                      scrapeResults.addAll(results);
                    });
                  },
                  child: const Text(
                    "Scrape Subreddit",
                  ),
                ),
              ],
            ),
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height - 268,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: false,
                separatorBuilder: (BuildContext context, int index) =>
                    const Gap(8),
                itemCount: scrapeResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        scrapeResults[index].title.length > 75
                            ? "${scrapeResults[index].title.substring(0, 50)}..."
                            : scrapeResults[index].title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        scrapeResults[index].content.length > 200
                            ? "${scrapeResults[index].content.substring(0, 200)}..."
                            : scrapeResults[index].content,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      leading: Text(
                        scrapeResults[index]
                            .content
                            .split(" ")
                            .length
                            .toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: scrapeResults[index].url,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.copy_rounded,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
