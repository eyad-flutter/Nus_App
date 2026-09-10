import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/favorites_controller.dart';
import '../data/news_model.dart';

/// Calculates estimated reading time in minutes based on total word count.
String calculateReadTime(String? content, String? description) {
  String text = "${description ?? ''} ${content ?? ''}".trim();
  if (text.isEmpty) return "1 min read";
  int words = text.split(RegExp(r'\s+')).length;
  int mins = (words / 200).ceil();
  return "$mins min read";
}

/// Builds an individual card widget for displaying favorite article details in a grid layout.
Widget buildFavoriteCard(
  BuildContext context,
  Results article,
  FavoriteController controller,
) {
  // Check whether a valid image URL exists
  final bool hasValidImage =
      article.imageUrl != null && article.imageUrl!.trim().isNotEmpty;

  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Article banner image with floating remove favorite button
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: hasValidImage
                  ? Image.network(
                      article.imageUrl!,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
            ),

            // Quick action remove button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => controller.toggleFavorite(article),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),

        // 2. Article text content and metadata footer
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Truncated article title
                Text(
                  article.title ?? 'favorites_Widgets_Msg_Title'.tr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),

                // Read time metadata and category badge chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        calculateReadTime(article.content, article.description),
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F52BA).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (article.category != null &&
                                article.category!.isNotEmpty)
                            ? article.category!.first.toUpperCase()
                            : 'favorites_Widgets_Msg_Category'.tr,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF0F52BA),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/// Helper widget to display when article image is unavailable or fails to load.
Widget _buildPlaceholderImage() {
  return Container(
    height: 110,
    width: double.infinity,
    color: Colors.grey[200],
    child: const Icon(Icons.newspaper, color: Colors.grey, size: 35),
  );
}

/// Displays placeholder screen layout when no favorite articles are saved.
Widget buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text(
          'favorites_Widgets_Msg_No_News'.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'favorites_Widgets_Msg_No_News_Des'.tr,
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
      ],
    ),
  );
}
