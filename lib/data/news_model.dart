import 'package:intl/intl.dart';

/// Top-level response model wrapper for NewsData.io API responses.
class Articles {
  String? status;
  int? totalResults;
  List<Results>? results;
  String? nextPage;

  Articles({this.status, this.totalResults, this.results, this.nextPage});

  /// Factory constructor to parse JSON response into [Articles] model.
  Articles.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    nextPage = json['nextPage'];
  }

  /// Converts [Articles] instance back to JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['nextPage'] = nextPage;
    return data;
  }
}

/// Represents an individual news article item parsed from the API response.
class Results {
  String? articleId;
  String? link;
  String? title;
  String? description;
  String? content;
  List<String>? keywords;
  List<String>? creator;
  String? language;
  List<String>? country;
  List<String>? category;
  String? datatype;
  String? pubDate;
  String? pubDateTZ;
  String? fetchedAt;
  String? imageUrl;
  String? videoUrl;
  String? sourceId;
  String? sourceName;
  int? sourcePriority;
  String? sourceUrl;
  String? sourceIcon;
  String? sentiment;
  String? sentimentStats;
  String? aiTag;
  String? aiRegion;
  String? aiOrg;
  String? aiSummary;
  bool? duplicate;

  Results({
    this.articleId,
    this.link,
    this.title,
    this.description,
    this.content,
    this.keywords,
    this.creator,
    this.language,
    this.country,
    this.category,
    this.datatype,
    this.pubDate,
    this.pubDateTZ,
    this.fetchedAt,
    this.imageUrl,
    this.videoUrl,
    this.sourceId,
    this.sourceName,
    this.sourcePriority,
    this.sourceUrl,
    this.sourceIcon,
    this.sentiment,
    this.sentimentStats,
    this.aiTag,
    this.aiRegion,
    this.aiOrg,
    this.aiSummary,
    this.duplicate,
  });

  /// Formats raw publication date string into a readable 'dd MMM yyyy' format.
  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "Unknown Date";
    try {
      DateTime parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return rawDate; // Fallback to raw string if parsing fails
    }
  }

  /// Parses JSON map to initialize a [Results] article object with safe type casting.
  Results.fromJson(Map<String, dynamic> json) {
    articleId = json['article_id']?.toString();
    link = json['link']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    content = json['content']?.toString();

    keywords = json['keywords'] != null
        ? List<String>.from(json['keywords'].map((x) => x.toString()))
        : [];
    creator = json['creator'] != null
        ? List<String>.from(json['creator'].map((x) => x.toString()))
        : [];
    language = json['language']?.toString();
    country = json['country'] != null
        ? List<String>.from(json['country'].map((x) => x.toString()))
        : [];
    category = json['category'] != null
        ? List<String>.from(json['category'].map((x) => x.toString()))
        : [];

    datatype = json['datatype']?.toString();
    pubDate = json['pubDate']?.toString();
    pubDateTZ = json['pubDateTZ']?.toString();
    fetchedAt = json['fetched_at']?.toString();
    imageUrl = json['image_url']?.toString();
    videoUrl = json['video_url']?.toString();
    sourceId = json['source_id']?.toString();
    sourceName = json['source_name']?.toString();
    sourcePriority = json['source_priority'] is int
        ? json['source_priority']
        : null;
    sourceUrl = json['source_url']?.toString();
    sourceIcon = json['source_icon']?.toString();
    sentiment = json['sentiment']?.toString();
    sentimentStats = json['sentiment_stats']?.toString();
    aiTag = json['ai_tag']?.toString();
    aiRegion = json['ai_region']?.toString();
    aiOrg = json['ai_org']?.toString();
    aiSummary = json['ai_summary']?.toString();
    duplicate = json['duplicate'] is bool ? json['duplicate'] : null;
  }

  /// Converts [Results] article instance back to JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['article_id'] = articleId;
    data['link'] = link;
    data['title'] = title;
    data['description'] = description;
    data['content'] = content;
    data['keywords'] = keywords;
    data['creator'] = creator;
    data['language'] = language;
    data['country'] = country;
    data['category'] = category;
    data['datatype'] = datatype;
    data['pubDate'] = pubDate;
    data['pubDateTZ'] = pubDateTZ;
    data['fetched_at'] = fetchedAt;
    data['image_url'] = imageUrl;
    data['video_url'] = videoUrl;
    data['source_id'] = sourceId;
    data['source_name'] = sourceName;
    data['source_priority'] = sourcePriority;
    data['source_url'] = sourceUrl;
    data['source_icon'] = sourceIcon;
    data['sentiment'] = sentiment;
    data['sentiment_stats'] = sentimentStats;
    data['ai_tag'] = aiTag;
    data['ai_region'] = aiRegion;
    data['ai_org'] = aiOrg;
    data['ai_summary'] = aiSummary;
    data['duplicate'] = duplicate;
    return data;
  }
}
