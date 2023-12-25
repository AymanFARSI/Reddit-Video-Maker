// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:reddit_video_maker/src/enums.dart';
import 'package:reddit_video_maker/src/global_vars.dart';
import 'package:reddit_video_maker/src/models.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<void> viewVideo() async {
  Uri uri = Uri.parse("file:${appModel.videoPath!}");
  try {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

Future<String> renderVideo(BuildContext ctx) async {
  String videoPath = "";
  if (appModel.title == null ||
      appModel.title!.isEmpty ||
      appModel.content == null ||
      appModel.url == null ||
      appModel.url!.isEmpty) {
    showSnackBar(ctx, "Fetch a post first!");
  }

  if (appModel.backgroundType == BackgroundType.Select) {
    showSnackBar(ctx, "Selecting a background is not supported yet!");
  }

  if (appModel.backgroundType == BackgroundType.Pick) {
    if (appModel.backgroundPath == null || appModel.backgroundPath!.isEmpty) {
      showSnackBar(ctx, "Pick a background first!");
    }
  }

  if (appModel.voiceType == VoiceType.Tiktok) {
    if (appModel.tiktokSessionID == null || appModel.tiktokSessionID!.isEmpty) {
      showSnackBar(ctx, "Enter a Tiktok session ID!");
    }
  }

  if (ttsPath.isEmpty) {
    showSnackBar(ctx, "Generate TTS first!");
  }

  String url = "http://127.0.0.1:9811/render";
  final body = {
    "url": appModel.postUrl!,
    // "username": username,
    // "password": password,
    "background": appModel.backgroundPath!,
  };
  final response = await http.post(Uri.parse(url), body: body);
  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    videoPath = json['path'];
  } else {
    showSnackBar(ctx, "Error rendering video! ${response.body}");
  }

  return videoPath;
}

Future<String> generateTts(BuildContext ctx) async {
  String path = "";
  if (appModel.tiktokSessionID == null || appModel.tiktokSessionID!.isEmpty) {
    showSnackBar(ctx, "Enter a Tiktok session ID!");
    return path;
  }

  if (appModel.title == null ||
      appModel.title!.isEmpty ||
      appModel.content == null ||
      appModel.url == null ||
      appModel.url!.isEmpty) {
    showSnackBar(ctx, "Fetch a post first!");
    return path;
  }

  String url = "http://127.0.0.1:9811/tts";
  final response = await http.post(
    Uri.parse(url),
    body: {
      "title": appModel.title,
      "text": appModel.content,
      "voice": appModel.tiktokVoice.toString().split(".")[1],
      "session_id": appModel.tiktokSessionID,
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    path = json['path'];
  } else {
    showSnackBar(ctx, "Error generating TTS! ${response.body}");
  }

  return path;
}

Future<List<ScrapeResult>> scrapeReddit(BuildContext ctx) async {
  List<ScrapeResult> results = [];
  if (appModel.scrapeType == ScrapeType.Subreddit) {
    if (appModel.subreddits == null || appModel.subreddits!.isEmpty) {
      showSnackBar(ctx, "Enter a subreddit to scrape!");
    } else {
      String url = "http://127.0.0.1:9811/scrape";
      final response = await http.post(
        Uri.parse(url),
        body: {
          "client_id": clientID,
          "client_secret": clientSecret,
          "subreddit": appModel.subreddits!,
          "sort": appModel.sort?.name ?? "hot",
          "limit": (appModel.limit ?? 5).toString(),
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        for (int i = 0; i < json["count"] - 1; i++) {
          final title = json['title'][i];
          final content = json['content'][i];
          final url = json['url'][i];
          results.add(
            ScrapeResult(
              title: title,
              content: content,
              url: url,
            ),
          );
        }
      } else {
        showSnackBar(ctx, "Error fetching post!");
      }
    }
  } else if (appModel.scrapeType == ScrapeType.PostID) {
    if (appModel.postUrl == null || appModel.postUrl!.isEmpty) {
      showSnackBar(ctx, "Enter a post ID to scrape!");
    } else {
      String url = "http://127.0.0.1:9811/fetch";
      final response = await http.post(
        Uri.parse(url),
        body: {
          "client_id": clientID,
          "client_secret": clientSecret,
          "url": appModel.postUrl!,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final title = json['title'];
        appModel.title = title;

        final content = json['content'];
        appModel.content = content;

        final url = json['url'];
        appModel.url = url;

        results.add(
          ScrapeResult(
            title: title,
            content: content,
            url: url,
          ),
        );
      } else {
        showSnackBar(ctx, "Error fetching post! ${response.body}");
      }
    }
  }
  return results;
}

void showSnackBar(BuildContext ctx, String text) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      width: 300,
      duration: const Duration(minutes: 5),
      behavior: SnackBarBehavior.floating,
      content: Text(text),
    ),
  );
}
