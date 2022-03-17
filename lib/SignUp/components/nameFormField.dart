import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class nameFormField extends StatelessWidget {
  const nameFormField({
    required this.size,
    required this.controller,
    required this.preixIcon,
    required this.hintText,
  });

  final Size size;
  final IconData preixIcon;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Container(
        height: size.height * 0.1,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              // validation function

              return ' cet champ est obligatoire ';
            } else
              return null;
          },
          controller: controller,
          decoration: InputDecoration(
              hintText: "$hintText",
              hintStyle: const TextStyle(
                color: Colors.blueAccent,
              ),
              prefixIcon: Icon(
                preixIcon,
                color: Colors.blueAccent,
              ),
              fillColor: Colors.white10, // the color of the inside box field
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10), //borderradius
              )),
        ),
      ),
    );
  }
}
