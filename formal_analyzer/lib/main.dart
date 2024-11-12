import 'package:flutter/material.dart';
import 'package:formal_analyzer/analyzer/analyzers/graph.dart';
import 'package:formal_analyzer/analyzer/analyzers/regexp.dart';
import 'package:formal_analyzer/analyzer/analyzers/keyword.dart';
import 'package:formal_analyzer/analyzer/semantic.dart';
import 'package:formal_analyzer/analyzer/types/graph.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SemanticAnalyzer semanticAnalyzer = SemanticAnalyzer();

    List<GraphNode> identifierGraph = [
      GraphNode("Letter", RegExpAnalyzer("[a-zA-Z]"),
          {"[a-zA-Z0-9_]": 1, "[^a-zA-Z0-9_]": null}),
      GraphNode("Symbol", RegExpAnalyzer("[a-zA-Z0-9_]"),
          {"[a-zA-Z0-9_]": 1, "[^a-zA-Z0-9_]": null})
    ];
    List<GraphNode> constantGraph = [
      GraphNode("StartConstant", RegExpAnalyzer(""),
          {"[+\\-]": 1, "[1-9]": 2, "0": 3}),
      GraphNode("Sign", RegExpAnalyzer("[+\\-]"), {"[1-2]": 2, "0": 3}),
      GraphNode("FirstDigit", RegExpAnalyzer("[1-9]"),
          {"[0-9]": 4, "\\.": 5, null: null}),
      GraphNode("Zero", RegExpAnalyzer("0"), {"\\.": 5, null: null}),
      GraphNode("Digit", RegExpAnalyzer("[0-9]"),
          {"[0-9]": 4, "\\.": 5, null: null}),
      GraphNode("Point", RegExpAnalyzer("\\."), {"[0-9]": 6}),
      GraphNode("DigitAfterPoint", RegExpAnalyzer("[0-9]"),
          {"[0-9]": 6, null: null})
    ];
    List<GraphNode> assignmentGraph = [
      GraphNode(
          "<AssignmentLeftSide>",
          GraphAnalyzer(
              AnalyzerGraph(identifierGraph, GraphTransition.toSymbol),
              semanticAnalyzer.identifier),
          {null: 1}),
      GraphNode(
          "<AssignmentOperator>",
          GraphAnalyzer(
              AnalyzerGraph([
                GraphNode("AssignmentOperator1", RegExpAnalyzer(":"),
                    {null: 1}),
                GraphNode("AssignmentOperator2", RegExpAnalyzer("="),
                    {null: null}),
              ], GraphTransition.toSymbol),
              semanticAnalyzer.add),
          {"[a-zA-Z]": 2, "[+\\-\\d]": 3}),
      GraphNode(
          "<AssignmentRightIdentifier>",
          GraphAnalyzer(
              AnalyzerGraph(identifierGraph, GraphTransition.toSymbol),
              semanticAnalyzer.identifier),
          {null: null}),
      GraphNode(
          "<AssignmentRightConstant>",
          GraphAnalyzer(AnalyzerGraph(constantGraph, GraphTransition.toSymbol),
              semanticAnalyzer.constant),
          {null: null}),
    ];

    Analyzer analyzer = GraphAnalyzer(AnalyzerGraph([
      GraphNode("Start", RegExpAnalyzer(""), {null: 1}),
      GraphNode(
          "<IF>",
          KeywordsAnalyzer(Keyword.IF, semanticAnalyzer.add),
          {null: 2}),
      GraphNode(
          "<ConditionalLeftOperand>",
          GraphAnalyzer(
              AnalyzerGraph(identifierGraph, GraphTransition.toSymbol),
              semanticAnalyzer.identifier),
          {"T": 6, null: 3}),
      GraphNode(
          "<ConditionalOperator>",
          GraphAnalyzer(
              AnalyzerGraph([
                GraphNode(
                    "<Operator>", RegExpAnalyzer("[><=]"), {null: null})
              ], GraphTransition.toSymbol),
              semanticAnalyzer.add),
          {"[a-zA-Z]": 4, "[+\\-\\d]": 5}),
      GraphNode(
          "<ConditionalRightOperandIdentifier>",
          GraphAnalyzer(
              AnalyzerGraph(identifierGraph, GraphTransition.toSymbol),
              semanticAnalyzer.identifier),
          {null: 6}),
      GraphNode(
          "<ConditionalRightOperandConstant>",
          GraphAnalyzer(AnalyzerGraph(constantGraph, GraphTransition.toSymbol),
              semanticAnalyzer.constant),
          {null: 6}),
      GraphNode(
          "<THEN>",
          KeywordsAnalyzer(Keyword.THEN, semanticAnalyzer.add),
          {null: 7}),
      GraphNode(
          "<Assignment>",
          GraphAnalyzer(AnalyzerGraph(assignmentGraph, GraphTransition.toWord),
              SemanticAnalyzer.skip),
          {"ELSI": 8, "ELSE": 9, "EN": 11}),
      GraphNode(
          "<ELSIF>",
          KeywordsAnalyzer(Keyword.ELSIF, semanticAnalyzer.add),
          {null: 2}),
      GraphNode(
          "<ELSE>",
          KeywordsAnalyzer(Keyword.ELSE, semanticAnalyzer.add),
          {null: 10}),
      GraphNode(
          "<AssignmentAfterElse>",
          GraphAnalyzer(AnalyzerGraph(assignmentGraph, GraphTransition.toWord),
              SemanticAnalyzer.skip),
          {"EN": 11}),
      GraphNode(
          "<END>",
          KeywordsAnalyzer(Keyword.END, semanticAnalyzer.add),
          {";": 12}),
      GraphNode(
          "<;>",
          RegExpAnalyzer.withSemantic(";", semanticAnalyzer.add),
          {null: null}),
    ], GraphTransition.toWord), SemanticAnalyzer.skip);

    AnalyzerPosition position = (0, 0);
    var (pos, exc, r) = analyzer.analyze(position,
        "IF  THEN1 THEN  S1 := G  ELSIF  R2 < 0  THEN  D:= GFD  ELSIF  R6 = R5 THEN  S4 := 15.3 ELSE  GF := DCSX15  END;");
    if (exc != null) exc.display();
    print(semanticAnalyzer.prettyCode);
    print(semanticAnalyzer.constants.join(", "));
    print(semanticAnalyzer.identifiers.join(", "));

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
