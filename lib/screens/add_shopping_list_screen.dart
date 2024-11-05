import 'package:flutter/material.dart';
import 'package:shoppinglist/database_helper.dart';
import 'package:shoppinglist/models/shopping_list.dart';
import 'package:shoppinglist/screens/shopping_list_screen.dart';

class AddShoppingListScreen extends StatelessWidget {
  final ShoppingList? currentList;

  const AddShoppingListScreen({super.key, this.currentList});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    if (currentList != null) {
      titleController.text = currentList!.title;
      descriptionController.text = currentList!.description;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title:
              Text(currentList == null ? 'Создать список' : 'Изменить список')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Заголовок',
                  labelText: 'Введите заголовок',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Описание',
                  labelText: 'Введите описание',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                onChanged: (str) {},
                maxLines: 5,
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  final String title = titleController.value.text;
                  final String description = descriptionController.value.text;
                  if (title.isEmpty) {
                    return;
                  }

                  final ShoppingList model = ShoppingList(
                      id: currentList?.id,
                      title: title,
                      description: description);

                  if (currentList == null) {
                    int listId = await DatabaseHelper.addList(model);

                    if (context.mounted) {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShoppingListScreen(
                              listId: listId,
                              title: title,
                              description: description),
                        ),
                      );
                    }
                  } else {
                    await DatabaseHelper.updateList(model);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(currentList == null ? 'Добавить' : 'Изменить')),
          ],
        ),
      ),
    );
  }
}
