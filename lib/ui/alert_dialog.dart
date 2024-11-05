import 'package:flutter/material.dart';
import 'package:shoppinglist/enums.dart';
import 'package:shoppinglist/helpers/database_helper.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
      {super.key, this.listId, required this.callback, required this.mode});

  final int? listId;
  final Function callback;
  final Mode mode;

  @override
  Widget build(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Нет"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget confirmButton = TextButton(
      child: const Text("Да"),
      onPressed: () async {
        if (mode == Mode.item) {
          await DatabaseHelper.deleteAllListItems(listId!);
        } else {
          await DatabaseHelper.deleteAllLists();
        }
        if (context.mounted) {
          Navigator.pop(context);
        }
        callback();
      },
    );

    return AlertDialog(
      icon: const CircleAvatar(
        backgroundColor: Colors.yellow,
        child: Icon(Icons.question_mark),
      ),
      title: Text(
          (mode == Mode.list) ? 'Удалить все списки' : 'Удалить все элементы?'),
      content: Text((mode == Mode.list)
          ? 'Вы действительно хотите удалить все списки?'
          : 'Вы действительно хотите удалить все элементы?'),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );
  }
}
