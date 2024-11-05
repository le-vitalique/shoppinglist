import 'package:flutter/material.dart';
import 'package:shoppinglist/enums.dart';

PopupMenuItem editMenuItem = const PopupMenuItem(
  value: Menu.edit,
  child: ListTile(
    leading: Icon(
      Icons.edit,
      color: Colors.green,
    ),
    title: Text('Изменить'),
  ),
);

PopupMenuItem deleteMenuItem = const PopupMenuItem(
  value: Menu.delete,
  child: ListTile(
    leading: Icon(Icons.delete_forever, color: Colors.red),
    title: Text('Удалить'),
  ),
);
