import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String brand;
  final String category;
  final double price; // selling price
  final double mrp; // original price (shown struck-through)
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> highlights;
  final IconData icon;
  final Color color;

  /// Optional product photo URLs (front, side, back, detail). If empty,
  /// coloured placeholder views are drawn instead.
  final List<String> images;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.mrp,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.highlights,
    required this.icon,
    required this.color,
    this.images = const [],
  });

  int get discountPercent => ((mrp - price) / mrp * 100).round();
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
  double get total => product.price * quantity;
  double get mrpTotal => product.mrp * quantity;
}

class Review {
  final String author;
  final int rating;
  final String title;
  final String body;
  final String date;
  final bool verified;
  const Review({
    required this.author,
    required this.rating,
    required this.title,
    required this.body,
    required this.date,
    required this.verified,
  });
}
