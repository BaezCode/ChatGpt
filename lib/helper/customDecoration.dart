import 'package:flutter/material.dart';

class CustomDecoration {
  CustomDecoration._();

  static buildInputDecoration(
    String hint,
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      hintStyle: const TextStyle(color: Colors.grey),
      labelStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.3))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.3))),
    );
  }
}
