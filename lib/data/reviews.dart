import '../models/product.dart';

List<Review> reviewsFor(Product p) => [
      Review(
          author: 'Ravi K.',
          rating: 5,
          title: 'Worth every rupee',
          body:
              'Excellent quality for the price. The ${p.name} arrived well packed and works exactly as described.',
          date: '12 Oct 2026',
          verified: true),
      Review(
          author: 'Priya S.',
          rating: 4,
          title: 'Good, with minor nitpicks',
          body:
              'Build quality is solid and delivery was quick. Would have loved a slightly longer warranty.',
          date: '03 Oct 2026',
          verified: true),
      Review(
          author: 'Anil M.',
          rating: 5,
          title: 'Highly recommended',
          body:
              'Bought this as a gift and it was a hit. The easy returns policy gave me the confidence to order.',
          date: '21 Sep 2026',
          verified: true),
      Review(
          author: 'Sneha R.',
          rating: 4,
          title: 'Value for money',
          body:
              'Does the job well. Packaging was neat and support answered my question the same day.',
          date: '09 Sep 2026',
          verified: false),
    ];

/// Percentage of 5,4,3,2,1 star ratings (approximation based on the average).
List<int> ratingDistribution(double rating) {
  final shift = ((rating - 4.3) * 20).round();
  final five = 60 + shift;
  const four = 22, three = 8, two = 4;
  final one = 100 - five - four - three - two;
  return [five, four, three, two, one];
}
