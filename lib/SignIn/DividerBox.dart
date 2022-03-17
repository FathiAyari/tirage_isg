import 'package:flutter/cupertino.dart';

class DividerBox extends StatelessWidget {
  const DividerBox({
    required this.size,
    required this.height,
  });

  final Size size;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * height,
    );
  }
}
