import 'dart:io';

import 'package:reddit_video_maker/src/models.dart';

AppModel appModel = AppModel();
final List<ScrapeResult> scrapeResults = <ScrapeResult>[];
final List<ScrapeResult> fetchResults = <ScrapeResult>[];
String ttsPath = "";

const String clientID = "";
const String clientSecret = "";
const String sessionID = "";

Process? apiProcess;
