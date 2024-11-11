import 'package:flutter/material.dart';
import 'package:formal_analyzer/analyzer/analyzer.dart';
import 'package:formal_analyzer/analyzer/patterns/keywords.dart';
import 'package:formal_analyzer/analyzer/states.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/state.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<GraphNode> identifierGraph = [
      GraphNode("Letter", RegExpAnalyzer("[a-zA-Z]"),
          {"[a-zA-Z0-9_]": 1, "[^a-zA-Z0-9_]": null}),
      GraphNode("Symbol", RegExpAnalyzer("[a-zA-Z0-9_]"),
          {"[a-zA-Z0-9_]": 1, "[^a-zA-Z0-9_]": null})
    ];
    List<GraphNode> constantGraph = [
      GraphNode("StartConstant", RegExpAnalyzer.spaces(),
          {"[+\\-]": 1, "[1-9]": 2, "0": 3}),
      GraphNode("Sign", RegExpAnalyzer("[+\\-]"), {"[1-2]": 2, "0": 3}),
      GraphNode("FirstDigit", RegExpAnalyzer("[1-9]"),
          {"[0-9]": 4, "\\.": 5, null: null}),
      GraphNode("Zero", RegExpAnalyzer("0"), {"\\.": 5, null: null}),
      GraphNode(
          "Digit", RegExpAnalyzer("[0-9]"), {"[0-9]": 4, "\\.": 5, null: null}),
      GraphNode("Point", RegExpAnalyzer("\\."), {"[0-9]": 6}),
      GraphNode(
          "DigitAfterPoint", RegExpAnalyzer("[0-9]"), {"[0-9]": 6, null: null})
    ];
    List<GraphNode> assignmentGraph = [
      GraphNode("<AssignmentLeftSide>",
          GraphAnalyzer(AnalyzerGraph.identifier(identifierGraph)), {null: 1}),
      GraphNode(
          "<AssignmentOperator>",
          GraphAnalyzer(AnalyzerGraph([
            GraphNode("AssignmentOperator1", RegExpAnalyzer(":"), {null: 1}),
            GraphNode("AssignmentOperator2", RegExpAnalyzer("="), {null: null}),
          ], TypeOfTransition.symbol, Save.noSave)),
          {"[a-zA-Z]": 2, "[+\\-\\d]": 3}),
      GraphNode(
          "<AssignmentRightIdentifier>",
          GraphAnalyzer(AnalyzerGraph.identifier(identifierGraph)),
          {null: null}),
      GraphNode("<AssignmentRightConstant>",
          GraphAnalyzer(AnalyzerGraph.constant(constantGraph)), {null: null}),
    ];

    Analyzer analyzer = GraphAnalyzer(AnalyzerGraph.root([
      GraphNode("Start", RegExpAnalyzer.spaces(), {null: 1}),
      const GraphNode("<IF>", KeywordsAnalyzer(Keyword.IF), {null: 2}),
      GraphNode(
          "<ConditionalLeftOperand>",
          GraphAnalyzer(AnalyzerGraph.identifier(identifierGraph)),
          {"T": 6, null: 3}),
      GraphNode(
          "<ConditionalOperator>",
          GraphAnalyzer(AnalyzerGraph([
            GraphNode("<Operator>", RegExpAnalyzer("[><=]"), {null: null})
          ], TypeOfTransition.symbol, Save.noSave)),
          {"[a-zA-Z]": 4, "[+\\-\\d]": 5}),
      GraphNode("<ConditionalRightOperandIdentifier>",
          GraphAnalyzer(AnalyzerGraph.identifier(identifierGraph)), {null: 6}),
      GraphNode("<ConditionalRightOperandConstant>",
          GraphAnalyzer(AnalyzerGraph.constant(constantGraph)), {null: 6}),
      const GraphNode(
          "<THEN>", KeywordsAnalyzer(Keyword.THEN), {null: 7}),
      GraphNode(
          "<Assignment>",
          GraphAnalyzer(AnalyzerGraph(
              assignmentGraph, TypeOfTransition.word, Save.noSave)),
          {"ELSI": 8, "ELSE": 9, "EN": 11}),
      const GraphNode(
          "<ELSIF>", KeywordsAnalyzer(Keyword.ELSIF), {null: 2}),
      const GraphNode("<ELSE>", KeywordsAnalyzer(Keyword.ELSE), {null: 10}),
      GraphNode(
          "<AssignmentAfterElse>",
          GraphAnalyzer(AnalyzerGraph(
              assignmentGraph, TypeOfTransition.word, Save.noSave)),
          {"EN": 11}),
      const GraphNode("<END>", KeywordsAnalyzer(Keyword.END), {";": 12}),
      GraphNode("<;>", RegExpAnalyzer(";"), {null: null}),
    ], TypeOfTransition.word));

    AnalyzerResult result = AnalyzerResult.empty();
    AnalyzerPosition position = (0, 0);
    var (pos, exc, r) = analyzer.analyze(
        position, "IF  R1 THEN  S1 := G  ELSIF  R2 < 0  THEN  D:= GFD  ELSIF  R6 = R5 THEN  S4 := 15.3 ELSE  GF := DCSX15  END;", result);
    print(r?.prettyCode);
    if (exc != null) exc.display();
    print(r?.constants.join(", "));
    print(r?.identifiers.join(", "));

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
