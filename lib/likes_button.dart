import 'package:flutter/material.dart';

class Likebutton extends StatelessWidget {
  final bool isliked;
  void Function()? onclicked;
  Likebutton({
    super.key,
    required this.isliked,
    required this.onclicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onclicked,
      child: Icon(
        isliked ? Icons.favorite : Icons.favorite_border,
        color: isliked ? Colors.red : Colors.grey,
      ),
    );
  }
}
