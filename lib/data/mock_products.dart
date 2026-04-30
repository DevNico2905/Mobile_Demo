import 'package:flutter/material.dart';
import '../models/product.dart';

const List<Category> categories = [
  Category(id: 'all', name: 'All', icon: Icons.all_inbox),
  Category(id: 'electronics', name: 'Electronics', icon: Icons.computer),
  Category(id: 'books', name: 'Books', icon: Icons.book),
  Category(id: 'clothing', name: 'Clothing', icon: Icons.checkroom),
  Category(id: 'home', name: 'Home', icon: Icons.home),
];

const List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Laptop',
    price: 1000,
    categoryId: 'electronics',
    icon: Icons.computer,
  ),
  Product(
    id: '2',
    name: 'Book',
    price: 10,
    categoryId: 'books',
    icon: Icons.book,
  ),
  Product(
    id: '3',
    name: 'Shirt',
    price: 20,
    categoryId: 'clothing',
    icon: Icons.checkroom,
  ),
  Product(
    id: '4',
    name: 'Table',
    price: 30,
    categoryId: 'home',
    icon: Icons.home,
  ),
];
