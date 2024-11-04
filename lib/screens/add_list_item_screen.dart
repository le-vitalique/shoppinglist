import 'package:flutter/material.dart';
import 'package:shoppinglist/database_helper.dart';
import 'package:shoppinglist/model/shopping_list_item.dart';

class AddListItemScreen extends StatelessWidget {
  const AddListItemScreen({super.key, required this.listId});

  final int listId;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Добавить элемент')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextFormField(
                controller: nameController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Название',
                  labelText: 'Введите название',
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
                  final name = nameController.value.text;
                  final description = descriptionController.value.text;
                  if (name.isEmpty || description.isEmpty) {
                    return;
                  }
                  final ShoppingListItem model = ShoppingListItem(
                      listId: listId, name: name, description: description);
                  {
                    await DatabaseHelper.addListItem(model);
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
