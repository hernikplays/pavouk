import 'package:flutter/material.dart';
import 'package:pavouk/okna/domov.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) => MaterialApp(
        title: 'Pavouk | subnetování',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        darkTheme: ThemeData.dark(),
        home: const DomovskaStrana(),
      ),
    );
  }
}
