import 'package:flutter/material.dart';
import 'package:shoppinglist/database_helper.dart';
import 'package:shoppinglist/model/shopping_list.dart';

class AddShoppingListScreen extends StatelessWidget {
  const AddShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Добавить список')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  final title = titleController.value.text;
                  final description = descriptionController.value.text;
                  if (title.isEmpty || description.isEmpty) {
                    return;
                  }
                  final ShoppingList model =
                      ShoppingList(title: title, description: description);
                  {
                    await DatabaseHelper.addList(model);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Добавить')),
          ],
        ),
      ),
    );
  }
}
