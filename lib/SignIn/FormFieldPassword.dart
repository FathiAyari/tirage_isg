import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormFieldPassword extends StatelessWidget {
  const FormFieldPassword({
    required this.size,
    required this.controller,
    required this.preixIcon,
    required this.suffixIcon,
    required this.obscuretext,
  });

  final Size size;
  final bool obscuretext;
  final IconData preixIcon;
  final IconButton suffixIcon;
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
          obscureText: obscuretext,
          decoration: InputDecoration(
              hintText: "Mot de passe",
              hintStyle: TextStyle(
                color: Colors.blueAccent,
              ),
              suffixIcon: (suffixIcon),
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
