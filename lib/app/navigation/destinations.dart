import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const destinations = [
  Destination(label: 'Home', icon: Icons.home),
  Destination(label: 'Categories', icon: Icons.create),
  Destination(label: 'Collections', icon: Icons.book_outlined),
  Destination(label: 'Profile', icon: Icons.person),
];

class Routes {
  Routes._();
  static const String authView = '/auth';
  static const String loadView = '/load';
  static const String homeView = '/home';
  static const String categoriesView = '/categories';
  static const String collectionsView = '/collections';
  static const String profileView = '/profile';
}
