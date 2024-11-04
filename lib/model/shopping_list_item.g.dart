// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) =>
    ShoppingListItem(
      id: (json['id'] as num?)?.toInt(),
      listId: (json['list_id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      done: ShoppingListItem._boolFromInt((json['done'] as num).toInt()),
    );

Map<String, dynamic> _$ShoppingListItemToJson(ShoppingListItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['list_id'] = instance.listId;
  val['name'] = instance.name;
  val['description'] = instance.description;
  val['done'] = ShoppingListItem._boolToInt(instance.done);
  return val;
}
