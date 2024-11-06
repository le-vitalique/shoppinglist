import 'package:flutter/material.dart';
import 'package:shoppinglist/ui/screens/shopping_lists_screen.dart';
import 'package:shoppinglist/ui/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: const ShoppingListsScreen(
        title: 'Список покупок',
      ),
    );
  }
}
