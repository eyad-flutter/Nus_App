import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/data/news_model.dart';

import '../view/news_details_screen.dart';

/// Renders a featured news banner card with background imagery, gradient overlays, and publication metadata.
class NewsBannerCard extends StatelessWidget {
  final Results article;

  const NewsBannerCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => NewsDetailsScreen(article: article),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 200),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(
              (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                  ? article.imageUrl!
                  : 'https://i.pinimg.com/1200x/b6/15/c7/b615c782113259698e122eb25d862cfe.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Dark gradient overlay for improved text contrast
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: Get.mediaQuery.size.height * 0.15),

                  // Article title text
                  Text(
                    article.title ?? "banner_Cards_Msg_Title".tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Publisher icon and source name header
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(
                              (article.sourceIcon != null &&
                                      article.sourceIcon!.isNotEmpty)
                                  ? article.sourceIcon!
                                  : 'https://i.pinimg.com/1200x/b6/15/c7/b615c782113259698e122eb25d862cfe.jpg',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: Get.mediaQuery.size.width * 0.02),
                      Flexible(
                        child: Text(
                          article.sourceName ?? "banner_Cards_Msg_Unknown".tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Formatted publication date chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article.formatDate(article.pubDate),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
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
