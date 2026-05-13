import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/book.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/enums.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final bool showProgress;
  final int? progress;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.showProgress = false,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  book.coverUrl != null
                      ? CachedNetworkImage(
                          imageUrl: book.coverUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.dividerLight,
                            child: const Center(
                              child: Icon(
                                Icons.book,
                                size: 40,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.dividerLight,
                            child: const Center(
                              child: Icon(
                                Icons.book,
                                size: 40,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.dividerLight,
                          child: const Center(
                            child: Icon(
                              Icons.book,
                              size: 40,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                  // Format badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: book.isEpub
                            ? AppColors.primary
                            : AppColors.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book.format == BookFormat.epub ? 'EPUB' : 'PDF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Progress bar
            if (showProgress && progress != null)
              LinearProgressIndicator(
                value: progress! / 100,
                backgroundColor: AppColors.dividerLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 3,
              ),
            // Book info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    if (book.author != null)
                      Text(
                        book.author!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withOpacity(0.7),
                            ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
