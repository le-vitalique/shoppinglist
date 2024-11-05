import 'package:flutter/material.dart';
import 'package:shoppinglist/database_helper.dart';
import 'package:shoppinglist/models/shopping_list_item.dart';
import 'package:shoppinglist/screens/add_list_item_screen.dart';
import 'package:shoppinglist/enums.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen(
      {super.key,
      required this.listId,
      required this.title,
      required this.description});

  final int listId;
  final String title;
  final String description;

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
                    builder: (context) => AddListItemScreen(
                        listId: widget.listId, currentItem: item)),
              );
              setState(() {});
            } else {
              await DatabaseHelper.deleteListItem(item.id!);
              setState(() {});
            }
          },
        ));
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
        await DatabaseHelper.deleteAllListItems(widget.listId);
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
        title: const Text("Удалить все элементы"),
        content: const Text('Вы действительно хотите удалить все элементы?'),
        actions: [
          cancelButton,
          confirmButton,
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, overflow: TextOverflow.ellipsis),
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
      body: Column(
        children: [
          (widget.description.isNotEmpty)
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: (Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    child: ListTile(
                        title: Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    )),
                  )),
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Padding(
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
                      if ((snapshot.data as List<ShoppingListItem>)
                          .isNotEmpty) {
                        return buildItems(snapshot.data);
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddListItemScreen(listId: widget.listId),
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
