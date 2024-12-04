import 'package:formal_analyzer/analyzer/analyzers/graph.dart';
import 'package:formal_analyzer/analyzer/analyzers/keyword.dart';
import 'package:formal_analyzer/analyzer/analyzers/regexp.dart';
import 'package:formal_analyzer/analyzer/semantic.dart';
import 'package:formal_analyzer/analyzer/types/graph.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

abstract class AnalyzerConstructor {
  static Analyzer createAnalyzer(SemanticAnalyzer semanticAnalyzer) {
    List<GraphNode> identifierGraph = [
      GraphNode(RegExpAnalyzer("[a-zA-Z]"),
          {"[a-zA-Z0-9_]": 1, "[^a-zA-Z0-9_]": null}),
      GraphNode(RegExpAnalyzer("[a-zA-Z0-9_]"),
          {"[a-zA-Z0-9_]": 1, "[^a-zA-Z0-9_]": null})
    ];
    List<GraphNode> constantGraph = [
      GraphNode(RegExpAnalyzer(""), {"[+\\-]": 1, "[1-9]": 2, "0": 3}),
      GraphNode(RegExpAnalyzer("[+\\-]"), {"[1-2]": 2, "0": 3}),
      GraphNode(RegExpAnalyzer("[1-9]"), {"[0-9]": 4, "\\.": 5, null: null}),
      GraphNode(RegExpAnalyzer("0"), {"\\.": 5, null: null}),
      GraphNode(RegExpAnalyzer("[0-9]"), {"[0-9]": 4, "\\.": 5, null: null}),
      GraphNode(RegExpAnalyzer("\\."), {"[0-9]": 6}),
      GraphNode(RegExpAnalyzer("[0-9]"), {"[0-9]": 6, null: null})
    ];
    List<GraphNode> assignmentGraph = [
      GraphNode(
          GraphAnalyzer(
              AnalyzerGraph(identifierGraph, GraphTransition.toSymbol),
              semanticAnalyzer.identifier),
          {null: 1}),
      GraphNode(
          GraphAnalyzer(
              AnalyzerGraph([
                GraphNode(RegExpAnalyzer(":"), {null: 1}),
                GraphNode(RegExpAnalyzer("="), {null: null}),
              ], GraphTransition.toSymbol),
              semanticAnalyzer.addWithSpace),
          {"[a-zA-Z]": 2, "[+\\-\\d]": 3}),
      GraphNode(
          GraphAnalyzer(
              AnalyzerGraph(identifierGraph, GraphTransition.toSymbol),
              semanticAnalyzer.identifier),
          {null: null}),
      GraphNode(
          GraphAnalyzer(AnalyzerGraph(constantGraph, GraphTransition.toSymbol),
              semanticAnalyzer.constant),
          {null: null}),
    ];

    Analyzer analyzer = GraphAnalyzer(AnalyzerGraph([
      GraphNode(RegExpAnalyzer(""), {null: 1}),
      GraphNode(KeywordsAnalyzer(Keyword.IF, semanticAnalyzer.add), {null: 2}),
      GraphNode(
          GraphAnalyzer(
              AnalyzerGraph(identifierGraph, GraphTransition.toSymbol),
              semanticAnalyzer.identifier),
          {"T": 6, null: 3}),
      GraphNode(
          GraphAnalyzer(
              AnalyzerGraph([
                GraphNode(RegExpAnalyzer("[><=]"), {null: null})
              ], GraphTransition.toSymbol),
              semanticAnalyzer.addWithSpace),
          {"[a-zA-Z]": 4, "[+\\-\\d]": 5}),
      GraphNode(
          GraphAnalyzer(
              AnalyzerGraph(identifierGraph, GraphTransition.toSymbol),
              semanticAnalyzer.identifier),
          {null: 6}),
      GraphNode(
          GraphAnalyzer(AnalyzerGraph(constantGraph, GraphTransition.toSymbol),
              semanticAnalyzer.constant),
          {null: 6}),
      GraphNode(
          KeywordsAnalyzer(Keyword.THEN, semanticAnalyzer.add), {null: 7}),
      GraphNode(
          GraphAnalyzer(AnalyzerGraph(assignmentGraph, GraphTransition.toWord)),
          {"ELSI": 8, "ELSE": 9, "EN": 11}),
      GraphNode(
          KeywordsAnalyzer(Keyword.ELSIF, semanticAnalyzer.add), {null: 2}),
      GraphNode(
          KeywordsAnalyzer(Keyword.ELSE, semanticAnalyzer.add), {null: 10}),
      GraphNode(
          GraphAnalyzer(AnalyzerGraph(assignmentGraph, GraphTransition.toWord)),
          {"EN": 11}),
      GraphNode(KeywordsAnalyzer(Keyword.END, semanticAnalyzer.add), {";": 12}),
      GraphNode(RegExpAnalyzer(";", semanticAnalyzer.add), {null: null}),
    ], GraphTransition.toWord));
    return analyzer;
  }
}
