import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:test/controller/favorites_controller.dart';
import 'package:test/controller/news_controller.dart';
import 'package:test/data/news_model.dart';

/// Displays detailed information for a selected news article.
class NewsDetailsScreen extends StatelessWidget {
  final Results article;

  const NewsDetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // Locate registered NewsController instance
    final NewsController controller = Get.find<NewsController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // 1. Flexible header displaying article banner image, title, and gradient overlay
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: Colors.black,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.white,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  if (article.link != null) {
                    controller.openArticleUrl(article.link);
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Article featured image with fallback state
                    Image.network(
                      (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                          ? article.imageUrl!
                          : 'https://via.placeholder.com/600x400',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.newspaper,
                          size: 60,
                          color: Colors.white54,
                        ),
                      ),
                    ),

                    // Gradient overlay to enhance readability of title text
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.9),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),

                    // Category chip and article headline text
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category badge chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F52BA),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              (article.category != null &&
                                      article.category!.isNotEmpty)
                                  ? article.category!.first.toUpperCase()
                                  : 'news_Details_Msg_Category'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Main article title
                          Text(
                            article.title ?? 'news_Details_Msg_Title'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Article content body with interactive favorite and share buttons
          SliverToBoxAdapter(
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Floating action buttons (Favorite & Share)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GetBuilder<FavoriteController>(
                          builder: (favController) {
                            final isFav = favController.isFavorite(article);
                            return _buildActionButton(
                              context: context,
                              icon: isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFav
                                  ? Colors.red
                                  : Theme.of(
                                      context,
                                    ).textTheme.titleLarge!.color!,
                              onPressed: () =>
                                  favController.toggleFavorite(article),
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        _buildActionButton(
                          context: context,
                          icon: Icons.share_outlined,
                          color: Theme.of(context).textTheme.titleLarge!.color!,
                          onPressed: () {
                            if (article.link != null) {
                              SharePlus.instance.share(
                                ShareParams(text: article.link!),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Publisher and source information header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: article.sourceIcon != null
                              ? NetworkImage(article.sourceIcon!)
                              : null,
                          backgroundColor: Colors.blueAccent.withValues(
                            alpha: 0.1,
                          ),
                          child: article.sourceIcon == null
                              ? const Icon(
                                  Icons.public,
                                  color: Color(0xFF0F52BA),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.sourceName ??
                                    'news_Details_Msg_Source'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${article.pubDate ?? 'news_Details_Msg_Date'.tr} • ${article.creator?.isNotEmpty == true ? article.creator!.first : 'news_Details_Msg_Creator'.tr}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1),
                    ),

                    // Optional AI Summary Block
                    if (article.aiSummary != null &&
                        article.aiSummary!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 16,
                                  color: Color(0xFF0F52BA),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "news_Details_Ai".tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F52BA),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              article.aiSummary!,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Article description preview text
                    if (article.description != null)
                      Text(
                        article.description!,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),

                    const SizedBox(height: 14),

                    // Full article content or fallback description text
                    Text(
                      article.content ??
                          article.description ??
                          'news_Details_Description'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Theme.of(
                          context,
                        ).textTheme.titleLarge?.color?.withValues(alpha: 0.2),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget for rendering circular glassMorphic action buttons.
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
