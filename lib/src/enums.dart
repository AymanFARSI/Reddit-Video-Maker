// ignore_for_file: constant_identifier_names

enum ScrapeType {
  Subreddit,
  PostID,
}

enum SubredditSort {
  Hot,
  New,
  Top,
  Rising;

  String get name {
    switch (this) {
      case SubredditSort.Hot:
        return 'hot';
      case SubredditSort.New:
        return 'new';
      case SubredditSort.Top:
        return 'top';
      case SubredditSort.Rising:
        return 'rising';
    }
  }
}

enum VoiceType {
  Tiktok;

  String get name {
    switch (this) {
      case VoiceType.Tiktok:
        return 'tiktok';
    }
  }
}

enum TiktokVoices {
  en_au_001,
  en_au_002,
  en_uk_001,
  en_uk_003,
  en_us_001,
  en_us_002,
  en_us_006,
  en_us_007,
  en_us_009,
  en_us_010,
  en_male_narration,
  en_male_funny,
  en_female_emotional,
  en_male_cody;

  String get name {
    switch (this) {
      case TiktokVoices.en_au_001:
        return "English AU - Female";
      case TiktokVoices.en_au_002:
        return "English AU - Male";
      case TiktokVoices.en_uk_001:
        return "English UK - Male 1";
      case TiktokVoices.en_uk_003:
        return "English UK - Male 2";
      case TiktokVoices.en_us_001:
        return "English US - Female (Int. 1)";
      case TiktokVoices.en_us_002:
        return "English US - Female (Int. 2)";
      case TiktokVoices.en_us_006:
        return "English US - Male 1";
      case TiktokVoices.en_us_007:
        return "English US - Male 2";
      case TiktokVoices.en_us_009:
        return "English US - Male 3";
      case TiktokVoices.en_us_010:
        return "English US - Male 4";
      case TiktokVoices.en_male_narration:
        return "Narrator";
      case TiktokVoices.en_male_funny:
        return "Funny";
      case TiktokVoices.en_female_emotional:
        return "Peaceful";
      case TiktokVoices.en_male_cody:
        return "Serious";
    }
  }
}

enum BackgroundType {
  Select,
  Pick,
}