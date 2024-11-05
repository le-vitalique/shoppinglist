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
        ? const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          )
        : const Icon(Icons.circle_outlined);
    return doneIcon;
  }

  Widget itemListTile(ShoppingListItem item) {
    print(item.done);
    return ListTile(
      onTap: () {},
      onLongPress: () {},
      leading: IconButton(
        icon: doneButton(item.done),
        onPressed: () async {
          item.done = !(item.done);
          await DatabaseHelper.setDoneItem(item);
          setState(() {});
        },
      ),
      title: Text(
        item.name,
        style: (item.done == true)
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : const TextStyle(),
      ),
      subtitle: (item.description.isNotEmpty)
          ? Text(
              item.description,
              style: (item.done == true)
                  ? const TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.lineThrough)
                  : const TextStyle(fontStyle: FontStyle.italic),
            )
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () async {
          await DatabaseHelper.deleteListItem(item.id!);
          setState(() {});
        },
      ),
    );
  }

  Widget buildItems(List<ShoppingListItem> list) => ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: itemListTile(list[index]),
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
                if ((snapshot.data as List<ShoppingListItem>).isNotEmpty) {
                  return buildItems(snapshot.data);
                } else {
                  return const Center(
                    child: Text('Тут пока пусто'),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
