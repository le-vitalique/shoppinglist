import 'package:flutter/material.dart';
import 'package:shoppinglist/database_helper.dart';
import 'package:shoppinglist/enums.dart';
import 'package:shoppinglist/model/shopping_list.dart';
import 'package:shoppinglist/screens/add_shopping_list_screen.dart';
import 'package:shoppinglist/screens/shopping_list_screen.dart';

class ShoppingListsScreen extends StatefulWidget {
  const ShoppingListsScreen({super.key, required this.title});

  final String title;

  @override
  State<ShoppingListsScreen> createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> {



  Widget listListTile(ShoppingList list) {
    return ListTile(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShoppingListScreen(
                listId: list.id!,
                title: list.title,
                description: list.description),
          ),
        );
        setState(() {});
      },
      leading: const CircleAvatar(
        child: Icon(Icons.shopping_cart),
      ),
      title: Text(list.title),
      subtitle: (list.description.isNotEmpty)
          ? Text(
              list.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontStyle: FontStyle.italic),
            )
          : null,
      trailing: PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return const [
            PopupMenuItem(
              value: Menu.edit,
              child: ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
                title: Text('Изменить'),
              ),
            ),
            PopupMenuItem(
              value: Menu.delete,
              child: ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: Text('Удалить'),
              ),
            )
          ];
        },
        onSelected: (value) async {
          if (value == Menu.edit) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddShoppingListScreen(currentList: list),
              ),
            );
            setState(() {});
          } else {
            await DatabaseHelper.deleteList(list.id!);
            setState(() {});
          }
        },
      ),
    );
  }

  Widget buildLists(List<ShoppingList> list) => ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: listListTile(list[index]),
          );
        },
      );

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
        await DatabaseHelper.deleteAllLists();
        setState(() {});
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
    // set up the AlertDialog
    Widget confirmDialog() {
      return AlertDialog(
        icon: const CircleAvatar(
          backgroundColor: Colors.yellow,
          child: Icon(Icons.question_mark),
        ),
        title: const Text("Удалить все списки"),
        content: const Text('Вы действительно хотите удалить все списки?'),
        actions: [
          cancelButton,
          confirmButton,
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {
                // show the dialog
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return confirmDialog();
                  },
                );
              },
              icon: const Icon(Icons.delete_sweep))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: DatabaseHelper.getAllLists(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('none');
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return const Text('active');
              case ConnectionState.done:
                if ((snapshot.data as List<ShoppingList>).isNotEmpty) {
                  return buildLists(snapshot.data);
                } else {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.not_interested),
                        Text('Тут пока пусто'),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddShoppingListScreen(),
            ),
          );
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
