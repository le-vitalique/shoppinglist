import 'package:flutter/material.dart';
import 'package:shoppinglist/database_helper.dart';
import 'package:shoppinglist/model/shopping_list_item.dart';

class AddListItemScreen extends StatelessWidget {
  const AddListItemScreen({super.key, required this.listId, this.currentItem});

  final int listId;
  final ShoppingListItem? currentItem;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    if (currentItem != null) {
      nameController.text = currentItem!.name;
      descriptionController.text = currentItem!.description;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title:
              Text((currentItem == null) ? 'Добавить элемент' : 'Изменить элемент')),
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
                  if (name.isEmpty) {
                    return;
                  }
                  final ShoppingListItem model = ShoppingListItem(
                      id:currentItem?.id, listId: listId, name: name, description: description);

                  if (currentItem == null) {
                    await DatabaseHelper.addListItem(model);
                  } else {
                    await DatabaseHelper.updateListItem(model);
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text((currentItem == null) ? 'Добавить' : 'Изменить')),
          ],
        ),
      ),
    );
  }
}
