import 'package:flutter/material.dart';
import 'package:shoppinglist/helpers/database_helper.dart';
import 'package:shoppinglist/models/shopping_list_item.dart';
import 'package:shoppinglist/ui/dialogs.dart';
import 'package:shoppinglist/ui/popup_menu_items.dart';
import 'package:shoppinglist/ui/screens/add_list_item_screen.dart';
import 'package:shoppinglist/enums.dart';
import 'package:shoppinglist/ui/widgets.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen(
      {super.key,
      required this.listId,
      required this.title,
      required this.description,
      required this.databaseHelper});

  final int listId;
  final String title;
  final String description;
  final DatabaseHelper databaseHelper;

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  Widget itemListTile(ShoppingListItem item) {
    return ListTile(
      leading: IconButton(
        icon: doneButton(item.done),
        onPressed: () async {
          item.done = !(item.done);
          await widget.databaseHelper.setDoneItem(item);
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: (item.done == true)
                  ? const TextStyle(
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.lineThrough)
                  : const TextStyle(fontStyle: FontStyle.italic),
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
                builder: (context) => AddListItemScreen(
                  listId: widget.listId,
                  currentItem: item,
                  databaseHelper: widget.databaseHelper,
                ),
              ),
            );
            setState(() {});
          } else {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDeleteOneDialog(
                  id: item.id!,
                  callback: () {
                    setState(() {});
                  },
                  mode: Mode.item,
                  databaseHelper: widget.databaseHelper,
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget buildItems(List<ShoppingListItem> list) => ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 100),
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
          FutureBuilder(
            future: widget.databaseHelper.getListItemCount(widget.listId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const SizedBox.shrink();
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                  return const SizedBox.shrink();
                case ConnectionState.done:
                  if ((snapshot.data) != 0) {
                    return IconButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDeleteAllDialog(
                              listId: widget.listId,
                              callback: () {
                                setState(() {});
                              },
                              mode: Mode.item,
                              databaseHelper: widget.databaseHelper,
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete_sweep),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          (widget.description.isNotEmpty)
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    child: ListTile(
                      title: Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: widget.databaseHelper.getListItems(widget.listId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Text('none');
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                      return const Text('active');
                    case ConnectionState.done:
                      if ((snapshot.data as List<ShoppingListItem>)
                          .isNotEmpty) {
                        return buildItems(snapshot.data);
                      } else {
                        return Center(child: emptyList());
                      }
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddListItemScreen(
                listId: widget.listId,
                databaseHelper: widget.databaseHelper,
              ),
            ),
          );
          setState(() {});
        },
        tooltip: 'Добавить элемент',
        child: const Icon(Icons.add),
      ),
    );
  }
}
