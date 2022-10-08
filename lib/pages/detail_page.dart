import 'package:flutter/material.dart';
import 'package:sample_flutter_202210/components/my_app_bar.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'detail',
      ),
      body: Container(),
    );
  }
}
