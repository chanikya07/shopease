import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final int? count;
  const StarRating(
      {super.key, required this.rating, this.size = 16, this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            rating >= i + 1
                ? Icons.star
                : (rating >= i + 0.5 ? Icons.star_half : Icons.star_border),
            size: size,
            color: AppTheme.star,
          ),
        if (count != null) ...[
          const SizedBox(width: 4),
          Text('($count)',
              style: TextStyle(fontSize: size * 0.8, color: AppTheme.muted)),
        ],
      ],
    );
  }
}
