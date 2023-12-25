import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment(
      {super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Comment
          Text(text),

          SizedBox(
            height: 3,
          ),

          Row(
            children: [
              Text(
                user,
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              const Text("."),
              Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          )
        ],
      ),
    );
  }
}
