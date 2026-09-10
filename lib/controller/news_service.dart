import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:test/data/news_model.dart';

/// Handles HTTP network requests to the NewsData.io API.
class NewsService {
  static const String _apiKey = "pub_065c25b246534f54a4b729e5e20b6a00";
  static const String _baseUrl = "https://newsdata.io/api/1";

  /// Fetches latest news articles from the API with optional pagination support.
  Future<Articles?> getNews({String? page}) async {
    try {
      // Construct endpoint URL with optional pagination token
      String urlString = "$_baseUrl/latest?apikey=$_apiKey&q=industrial";
      if (page != null && page.isNotEmpty) {
        urlString += "&page=$page";
      }

      final url = Uri.parse(urlString);
      log("Fetching URL: $url");

      final response = await http.get(url);
      log("Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Articles.fromJson(data);
      } else if (response.statusCode == 429) {
        // Handle API rate limit gracefully
        log("Rate limit reached. Stopping further requests.");
        return null;
      } else {
        log("NewsService Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e, stacktrace) {
      log("Exception in NewsService: $e");
      log("Stacktrace: $stacktrace");
      return null;
    }
  }
}
