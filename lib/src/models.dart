import 'package:reddit_video_maker/src/enums.dart';

class AppModel {
  ScrapeType scrapeType = ScrapeType.Subreddit;
  String? subreddits;
  int? limit;
  SubredditSort? sort;
  String? postUrl;

  String? title = "";
  String? content = "";
  String? url = "";

  VoiceType voiceType = VoiceType.Tiktok;
  String? tiktokSessionID;
  TiktokVoices tiktokVoice = TiktokVoices.en_us_002;

  BackgroundType backgroundType = BackgroundType.Pick;
  String? backgroundPath;

  String? videoPath;
}

class ScrapeResult {
  String title;
  String content;
  String url;

  ScrapeResult({
    required this.title,
    required this.content,
    required this.url,
  });
}
