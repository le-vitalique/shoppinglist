import 'package:flutter/material.dart';
import 'package:shoppinglist/database_helper.dart';
import 'package:shoppinglist/model/shopping_list_item.dart';
import 'package:shoppinglist/screens/add_list_item_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen(
      {super.key, required this.listId, required this.title});

  final int listId;
  final String title;

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  Widget doneButton(bool? done) {
    Icon doneIcon = (done ?? false)
        ? const Icon(Icons.check_circle_outline)
        : const Icon(Icons.circle_outlined);
    return doneIcon;
  }

  Widget buildLists(List<ShoppingListItem> list) => ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {},
              leading: IconButton(
                icon: doneButton(list[index].done!),
                onPressed: () async {
                  list[index].done = !(list[index].done ?? false);
                  await DatabaseHelper.setDoneItem(list[index]);
                  setState(() {});
                },
              ),
              title: Text(
                list[index].name,
                style: (list[index].done == true)
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : const TextStyle(),
              ),
              subtitle: Text(
                list[index].description,
                style: (list[index].done == true)
                    ? const TextStyle(fontStyle: FontStyle.italic, decoration: TextDecoration.lineThrough)
                    : const TextStyle(fontStyle: FontStyle.italic),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () async {
                  await DatabaseHelper.deleteListItem(list[index].id!);
                  setState(() {});
                },
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddListItemScreen(listId: widget.listId),
                  ),
                );
                setState(() {});
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: DatabaseHelper.getListItems(widget.listId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('none');
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return const Text('active');
              case ConnectionState.done:
                return buildLists(snapshot.data);
            }
          },
        ),
      ),
    );
  }
}
