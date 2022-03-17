import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoMessage extends StatelessWidget {
  final String message;
  final void Function() press;

  InfoMessage({required this.message, required this.press});

  show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: this,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(this.message),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: press, child: Text("Confirmer"))
        ],
      ),
    );
  }
}
