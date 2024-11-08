import 'package:flutter/material.dart';
import 'package:shoppinglist/enums.dart';
import 'package:shoppinglist/helpers/database_helper.dart';
import 'package:shoppinglist/models/shopping_list_item.dart';
import 'package:shoppinglist/ui/widgets.dart';

class AddListItemScreen extends StatelessWidget {
  AddListItemScreen({super.key, required this.listId, this.currentItem});

  final int listId;
  final ShoppingListItem? currentItem;
  final _itemFormKey = GlobalKey<FormState>();

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
        title: Text(
            (currentItem == null) ? 'Добавить элемент' : 'Изменить элемент'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Form(
              key: _itemFormKey,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: nameFormField(
                        controller: nameController, mode: Mode.item),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: descriptionFormField(descriptionController),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_itemFormKey.currentState!.validate()) {
                        final String name = nameController.value.text;
                        final String description =
                            descriptionController.value.text;

                        final ShoppingListItem model = ShoppingListItem(
                            id: currentItem?.id,
                            listId: listId,
                            name: name,
                            description: description);

                        if (currentItem == null) {
                          await DatabaseHelper.instance.addListItem(model);
                        } else {
                          await DatabaseHelper.instance.updateListItem(model);
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child:
                        Text((currentItem == null) ? 'Добавить' : 'Изменить'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
