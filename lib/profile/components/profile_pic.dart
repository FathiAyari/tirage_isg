import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePic extends StatelessWidget {
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage("${user['url']}"),
          ),
        ],
      ),
    );
  }
}
