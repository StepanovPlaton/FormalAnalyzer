import 'dart:math' show max;

import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

class GraphNode {
  final String name;
  final Analyzer analyzer;
  final Map<String?, int?> nextStates;
  const GraphNode(this.name, this.analyzer, this.nextStates);
}

enum TypeOfTransition {
  word,
  symbol
}
enum Save {
  identifier,
  constant,
  noSave
}

class Graph {
  final List<GraphNode> states;
  int? currentNodeIndex = 0;

  GraphNode? get currentNode {
    if (currentNodeIndex != null) {
      return states[currentNodeIndex!];
    } else {
      return null;
    }
  }

  Graph(this.states);
}


class AnalyzerGraph extends Graph {
  late TypeOfTransition typeOfTransition;
  late Save saveToListOf;
  AnalyzerGraph.root(super.states, this.typeOfTransition) {
    saveToListOf = Save.noSave;
  }
  AnalyzerGraph.identifier(super.states) {
    typeOfTransition = TypeOfTransition.symbol;
    saveToListOf = Save.identifier;
  }
  AnalyzerGraph.constant(super.states) {
    typeOfTransition = TypeOfTransition.symbol;
    saveToListOf = Save.constant;
  }
  AnalyzerGraph(super.states, this.typeOfTransition, this.saveToListOf);

  AnalysisTransitionFunction get next {
    if (typeOfTransition == TypeOfTransition.word) {
      return nextWord;
    } else {
      return nextSymbol;
    }
  }

  (AnalyzerPosition, AnalyzerException?) nextWord(
      AnalyzerPosition startPosition, String code, AnalyzerResult result) {
    List<String> lines = code.split("\n");
    AnalyzerPosition position = startPosition;
    AnalyzerPosition? startWord;
    String substring = "";
    int maxLengthOfPatterns =
        currentNode!.nextStates.keys.map((k) => k?.length ?? 1).reduce(max);
    while (
        position.$1 < lines.length && position.$2 < lines[position.$1].length) {
      substring += lines[position.$1][position.$2];
      if (lines[position.$1][position.$2] != " " && startWord == null) {
        startWord = position;
      }

      for (String? pattern in currentNode!.nextStates.keys) {
        if (pattern == null) continue;
        if (substring.contains(RegExp(pattern))) {
          currentNodeIndex = currentNode?.nextStates[pattern];
          return (startWord!, null);
        }
      }

      if (substring.replaceAll(" ", "").length >= maxLengthOfPatterns) {
        if (currentNode!.nextStates.keys.contains(null)) {
          currentNodeIndex = currentNode?.nextStates[null];
          return (startWord!, null);
        }
        return (
          position,
          AnalyzerException(
              position,
              "Unexpected substring '$substring', the next state is unknown",
              AnalyzerExceptionType.syntactic)
        );
      }

      position = (position.$1, position.$2 + 1);
      if (position.$2 == lines[position.$1].length) {
        position = (position.$1 + 1, 0);
      }
    }

    if (currentNode!.nextStates.keys.contains(null)) {
      currentNodeIndex = currentNode?.nextStates[null];
      return (position, null);
    }

    return (
      position,
      AnalyzerException(
          position, "Unexpected end of the expression", AnalyzerExceptionType.syntactic)
    );
  }

  (AnalyzerPosition, AnalyzerException?) nextSymbol(
      AnalyzerPosition startPosition, String code, AnalyzerResult result) {
    List<String> lines = code.split("\n");
    AnalyzerPosition position = startPosition;
    if (position.$1 < lines.length && position.$2 < lines[position.$1].length) {
      for (String? pattern in currentNode?.nextStates.keys ?? []) {
        if(pattern == null) continue;
        if (lines[position.$1][position.$2].contains(RegExp(pattern))) {
          currentNodeIndex = currentNode?.nextStates[pattern];
          return (position, null);
        }
      }
    }
    if (currentNode!.nextStates.keys.contains(null)) {
      currentNodeIndex = currentNode?.nextStates[null];
      return (position, null);
    }

    return (
      position,
      AnalyzerException(
          position,
          "Unexpected character '${lines[position.$1][position.$2]}', next state undefined",
          AnalyzerExceptionType.syntactic)
    );
  }
}
