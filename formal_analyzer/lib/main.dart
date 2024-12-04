import 'package:flutter/material.dart';
import 'package:formal_analyzer/analyzer/analyzer.dart';
import 'package:formal_analyzer/analyzer/semantic.dart';
import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';
import 'package:formal_analyzer/ui.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<MainApp> {
  SemanticAnalyzer? semanticAnalyzer;
  AnalyzerException? exception;
  String? code;
  String? log;

  AppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: UI.layout([
      UI.codeInput(code ?? "", (newCode) {
        SemanticAnalyzer newSemanticAnalyzer = SemanticAnalyzer();
        Analyzer analyzer =
            AnalyzerConstructor.createAnalyzer(newSemanticAnalyzer);
        var (newException, result) = analyzer.beginAnalyze(newCode);
        setState(() {
          semanticAnalyzer = newSemanticAnalyzer;
          exception = newException;
          code = newCode;
          log = result?.analysisLog.join("\n");
        });
    }),
      UI.outputField("Formatted code:", semanticAnalyzer?.prettyCode ?? "", 10),
    ], [
      UI.outputField(
          "Analysis exceptions:",
          code != null && code != "" && exception != null
              ? exception!.toFormattedString(code!)
              : "",
          10),
      UI.outputField(
          "Identifiers:", (semanticAnalyzer?.identifiers ?? {}).join(", "), 1),
      UI.outputField(
          "Constants:", (semanticAnalyzer?.constants ?? {}).join(", "), 1),
      UI.outputField("Analysis log:", log ?? "", 5)
    ])));
  }
}
