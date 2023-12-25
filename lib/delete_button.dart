import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final void Function()? onTap;
  const MyWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.cancel),
    );
  }
}
