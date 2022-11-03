import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Vzhled {
  static final TextStyle nadpis = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle fieldNadpis =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp);

  static const TextStyle tlacitkoText = TextStyle(color: Colors.white);
  static final ButtonStyle tlacitkoStyl =
      ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red));
  static final TextStyle text = TextStyle(fontSize: 13.sp);
  static final TextStyle tableContent = TextStyle(fontSize: 11.sp);
}
