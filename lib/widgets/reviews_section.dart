import 'package:flutter/material.dart';
import '../data/reviews.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import 'star_rating.dart';

/// Customer reviews: rating summary with distribution + review list.
class ReviewsSection extends StatelessWidget {
  final Product product;
  const ReviewsSection({super.key, required this.product});

  Widget _summary() {
    final dist = ratingDistribution(product.rating);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${product.rating}',
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800)),
            const Padding(
              padding: EdgeInsets.only(bottom: 8, left: 4),
              child: Text('out of 5', style: TextStyle(color: AppTheme.muted)),
            ),
          ],
        ),
        StarRating(rating: product.rating, size: 22),
        const SizedBox(height: 4),
        Text('${product.reviewCount} verified ratings',
            style: const TextStyle(color: AppTheme.muted)),
        const SizedBox(height: 16),
        for (var i = 0; i < 5; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(width: 28, child: Text('${5 - i}\u2605')),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: dist[i] / 100,
                      minHeight: 8,
                      backgroundColor: AppTheme.border,
                      color: AppTheme.star,
                    ),
                  ),
                ),
                SizedBox(
                    width: 40,
                    child: Text('${dist[i]}%',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.muted))),
              ],
            ),
          ),
      ],
    );
  }

  Widget _tile(Review r) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.navy,
                child: Text(r.author[0],
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Text(r.author, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              if (r.verified)
                const Row(children: [
                  Icon(Icons.verified, size: 14, color: AppTheme.success),
                  SizedBox(width: 3),
                  Text('Verified purchase',
                      style: TextStyle(fontSize: 11, color: AppTheme.success)),
                ]),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            StarRating(rating: r.rating.toDouble(), size: 15),
            const SizedBox(width: 8),
            Text(r.date,
                style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
          ]),
          const SizedBox(height: 8),
          Text(r.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(r.body, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviews = reviewsFor(product);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Customer Reviews',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final list = Column(children: [for (final r in reviews) _tile(r)]);
          if (c.maxWidth >= 800) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 280, child: _summary()),
                const SizedBox(width: 40),
                Expanded(child: list),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_summary(), const SizedBox(height: 20), list],
          );
        }),
      ],
    );
  }
}
