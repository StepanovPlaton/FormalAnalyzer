import 'package:flutter/material.dart';
import 'package:formal_analyzer/analyzer/analyzer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Analyzer analyzer = Analyzer();
    var (exc, r) = analyzer.analyze("    IF AB> \n C THEN \n\n B=F \n");
    print(r.prettyCode);
    if(exc != null) exc.display();

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
