import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class emailFormField extends StatelessWidget {
  const emailFormField({
    required this.size,
    required this.controller,
    required this.prefixIcon,
  });

  final Size size;

  final IconData prefixIcon;

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
            } else if (!value.contains("@")) {
              return "format d'email incorrecte ";
            } else
              return null;
          },
          keyboardType: TextInputType.emailAddress,
          controller: controller,
          decoration: InputDecoration(
              prefixIcon: Icon(
                prefixIcon,
                color: Colors.blueAccent,
              ),
              hintText: "Email",
              hintStyle: TextStyle(
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
