import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/data/news_model.dart';

import '../controller/favorites_controller.dart';
import '../view/news_details_screen.dart';

/// Renders a standard horizontal list news card with source metadata, category tags, and favorite toggles.
class NewsCard extends StatelessWidget {
  final Results article;

  const NewsCard({super.key, required this.article});

  /// Calculates estimated reading time based on article content and description word count.
  String calculateReadTime(String? content, String? description) {
    String text = "${description ?? ''} ${content ?? ''}".trim();
    if (text.isEmpty) return "1 min read";
    int words = text.split(RegExp(r'\s+')).length;
    int mins = (words / 200).ceil();
    return "$mins min read";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => NewsDetailsScreen(article: article),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 200),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        height: 110,
        child: Row(
          children: [
            // 1. Article banner thumbnail image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                    ? article.imageUrl!
                    : 'https://via.placeholder.com/150',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.newspaper, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 2. Vertical metadata column content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Category tag chip & favorite toggle button
                  Row(
                    children: [
                      Text(
                        (article.category != null &&
                                article.category!.isNotEmpty)
                            ? article.category!.first.toUpperCase()
                            : 'News_Card_Msg_Category'.tr,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      GetBuilder<FavoriteController>(
                        builder: (controller) {
                          final isFav = controller.isFavorite(article);
                          return IconButton(
                            icon: isFav
                                ? const Icon(Icons.favorite, size: 18)
                                : const Icon(Icons.favorite_border, size: 18),
                            color: isFav ? Colors.red : Colors.grey[700]!,
                            onPressed: () => controller.toggleFavorite(article),
                          );
                        },
                      ),
                    ],
                  ),

                  // Article headline title
                  Text(
                    article.title ?? 'News_Card_Msg_Title'.tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),

                  // Footer metadata row (Source logo, publisher name, publication date, read duration)
                  Row(
                    children: [
                      // Source logo icon
                      CircleAvatar(
                        radius: 8,
                        backgroundImage: article.sourceIcon != null
                            ? NetworkImage(article.sourceIcon!)
                            : null,
                        backgroundColor: Colors.blueAccent.withValues(
                          alpha: 0.2,
                        ),
                        child: article.sourceIcon == null
                            ? const Icon(
                                Icons.public,
                                size: 10,
                                color: Colors.blue,
                              )
                            : null,
                      ),
                      const SizedBox(width: 5),

                      // Publisher name
                      Flexible(
                        child: Text(
                          article.sourceName ?? 'News_Card_Msg_Source'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Text(" • ", style: TextStyle(color: Colors.grey[400])),

                      // Date string
                      Text(
                        article.pubDate != null
                            ? article.pubDate!.split(' ').first
                            : 'News_Card_Msg_Date'.tr,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),

                      Text(" • ", style: TextStyle(color: Colors.grey[400])),

                      // Estimated reading time
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 2),
                      Text(
                        calculateReadTime(article.content, article.description),
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
