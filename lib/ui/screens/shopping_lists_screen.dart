import 'package:flutter/material.dart';
import 'package:shoppinglist/helpers/database_helper.dart';
import 'package:shoppinglist/enums.dart';
import 'package:shoppinglist/models/shopping_list.dart';
import 'package:shoppinglist/ui/alert_dialog.dart';
import 'package:shoppinglist/ui/popup_menu_items.dart';
import 'package:shoppinglist/ui/screens/add_shopping_list_screen.dart';
import 'package:shoppinglist/ui/screens/shopping_list_screen.dart';
import 'package:shoppinglist/ui/widgets.dart';

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
          return [editMenuItem, deleteMenuItem];
        },
        onSelected: (value) async {
          if (value == Menu.edit) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddShoppingListScreen(currentList: list),
              ),
            );
          } else {
            await DatabaseHelper.deleteList(list.id!);
          }
          setState(() {});
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmDialog(
                    callback: () {
                      setState(() {});
                    },
                    mode: Mode.list,
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_sweep),
          )
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
                  return Center(child: emptyList());
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
        tooltip: 'Добавить список',
        child: const Icon(Icons.add),
      ),
    );
  }
}
