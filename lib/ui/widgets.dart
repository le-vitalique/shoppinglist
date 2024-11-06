import 'package:flutter/material.dart';
import 'package:shoppinglist/enums.dart';

Widget emptyList() {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.not_interested,
          size: 32,
        ),
      ),
      Text(
        'Тут пока пусто',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget nameFormField({TextEditingController? controller, required mode}) {
  return TextFormField(
    validator: (value) {
      value ??= '';
      return (value.isEmpty) ? 'Заполните поле' : null;
    },
    autovalidateMode: AutovalidateMode.onUserInteraction,
    controller: controller,
    maxLines: 1,
    decoration: InputDecoration(
      hintText: (mode == Mode.list) ? 'Заголовок' : 'Название',
      labelText: (mode == Mode.list) ? 'Введите заголовок' : 'Введите название',
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    ),
  );
}

var titleFormField = nameFormField;

Widget descriptionFormField(TextEditingController? controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      hintText: 'Описание',
      labelText: 'Введите описание (опционально)',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    ),
    keyboardType: TextInputType.multiline,
    onChanged: (value) {},
    maxLines: 5,
  );
}

Widget doneButton(bool? done) {
  Icon doneIcon = (done ?? false)
      ? const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
        )
      : const Icon(Icons.circle_outlined);
  return doneIcon;
}
