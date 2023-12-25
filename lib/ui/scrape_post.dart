import 'package:reddit_video_maker/src/global_vars.dart';
import 'package:reddit_video_maker/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ScrapePostPage extends StatefulWidget {
  const ScrapePostPage({super.key});

  @override
  State<ScrapePostPage> createState() => _ScrapePostPageState();
}

class _ScrapePostPageState extends State<ScrapePostPage> {
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
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextFormField(
                    initialValue: appModel.postUrl,
                    onChanged: (String value) {
                      appModel.postUrl = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter post ID",
                      label: Text(
                        "Post ID",
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final results = await scrapeReddit(context);
                    setState(() {
                      fetchResults.clear();
                      fetchResults.addAll(results);
                    });
                  },
                  child: const Text(
                    "Fetch post",
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
                itemCount: fetchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        fetchResults[index].title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        fetchResults[index].content,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.justify,
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
