import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}

class MyDropDownFormField<T> extends StatelessWidget {
  const MyDropDownFormField({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.itemValues,
    required this.validator,
    this.hintText,
  }) : super(key: key);

  final T? value;
  final void Function(T? value) onChanged;
  final List<String> items;
  final List<T> itemValues;
  final String? hintText;
  final String? Function(T?) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        items: items.asMap().entries.map((e) {
          return DropdownMenuItem(child: Text(e.value), value: itemValues[e.key]);
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
