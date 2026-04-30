import 'package:flutter/material.dart';
import '../models/product.dart';

const List<Category> categories = [
  Category(id: '0', name: 'All', icon: Icons.all_inbox),
  Category(id: '1', name: 'Electronics', icon: Icons.computer),
  Category(id: '2', name: 'Books', icon: Icons.book),
  Category(id: '3', name: 'Clothing', icon: Icons.checkroom),
  Category(id: '4', name: 'Home', icon: Icons.home),
];

const List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Laptop',
    price: 1000,
    categoryId: '1',
    icon: Icons.computer,
  ),
  Product(id: '2', name: 'Book', price: 10, categoryId: '2', icon: Icons.book),
  Product(
    id: '3',
    name: 'Shirt',
    price: 20,
    categoryId: '3',
    icon: Icons.checkroom,
  ),
  Product(id: '4', name: 'Table', price: 30, categoryId: '4', icon: Icons.home),
];
