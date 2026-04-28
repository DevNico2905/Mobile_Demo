import 'package:flutter/material.dart';

// Models productos e-commerce
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    this.icon = Icons.shopping_bag,
  });

  final String id;
  final String name;
  final double price;
  final String categoryId;
  final IconData icon;

  String get formattedPrice => '\$${price.toStringAsFixed(0)}';
}

// Categoria del catalogo

class Category {
  const Category({required this.id, required this.name, required this.icon});

  final String id;
  final String name;
  final IconData icon;
}
