import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tasweer/HomeScreen1.dart';
void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color(0xffededed),
      accentColor: const Color(0xff808080),
    ),
    home: HomeScreen(imageURL: "",),
  )
  );
}

