import 'package:flutter/material.dart';
import 'package:shoppinglist/enums.dart';
import 'package:shoppinglist/helpers/database_helper.dart';
import 'package:shoppinglist/models/shopping_list.dart';
import 'package:shoppinglist/ui/screens/shopping_list_screen.dart';
import 'package:shoppinglist/ui/widgets.dart';

class AddShoppingListScreen extends StatelessWidget {
  AddShoppingListScreen({super.key, this.currentList});

  final ShoppingList? currentList;
  final _listFormKey = GlobalKey<FormState>();

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
            Text((currentList == null) ? 'Создать список' : 'Изменить список'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Form(
              key: _listFormKey,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: titleFormField(
                        controller: titleController, mode: Mode.list),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: descriptionFormField(descriptionController),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_listFormKey.currentState!.validate()) {
                        final String title = titleController.value.text;
                        final String description =
                            descriptionController.value.text;

                        final ShoppingList model = ShoppingList(
                            id: currentList?.id,
                            title: title,
                            description: description);

                        if (currentList == null) {
                          int listId =
                              await DatabaseHelper.instance.addList(model);

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
                          await DatabaseHelper.instance.updateList(model);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                    child: Text(currentList == null ? 'Добавить' : 'Изменить'),
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
