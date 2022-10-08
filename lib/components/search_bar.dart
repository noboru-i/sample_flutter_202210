import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'search'
        ),
        onEditingComplete: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
