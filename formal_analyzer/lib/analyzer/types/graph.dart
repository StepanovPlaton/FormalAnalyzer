import 'dart:math' show max;

import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

class GraphNode {
  final Analyzer analyzer;
  final Map<String?, int?> nextStates;
  const GraphNode(this.analyzer, this.nextStates);
}

enum GraphTransition { toWord, toSymbol }

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
  late GraphTransition transition;
  AnalyzerGraph(super.states, this.transition);

  AnalysisTransitionFunction get next {
    if (transition == GraphTransition.toWord) {
      return nextWord;
    } else {
      return nextSymbol;
    }
  }

  (AnalyzerPosition, AnalyzerException?) nextWord(
      AnalyzerPosition startPosition, String code) {
    List<String> lines = code.split("\n");
    AnalyzerPosition position = startPosition;
    AnalyzerPosition? startWord;
    String substring = "";
    int maxLengthOfPatterns =
        currentNode!.nextStates.keys.map((k) => k?.length ?? 1).reduce(max);
        
    if (position.$1 < lines.length-1 && position.$2 == lines[position.$1].length) {
      position = (position.$1 + 1, 0);
    }
    while (
        position.$1 < lines.length && position.$2 < lines[position.$1].length) {
      substring += lines[position.$1][position.$2];
      if (lines[position.$1][position.$2] != " " && startWord == null) {
        startWord = position;
      }

      for (String? pattern in currentNode!.nextStates.keys) {
        if (pattern == null) continue;
        if (substring.toUpperCase().contains(RegExp(pattern))) {
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
          SyntacticAnalyzerException(
            position,
            "Unexpected substring '$substring', the next state is unknown",
          )
        );
      }

      position = (position.$1, position.$2 + 1);
      if (position.$2 == lines[position.$1].length) {
        if(position.$1 == lines.length - 1) break;
        position = (position.$1 + 1, 0);
      }
    }

    if (currentNode!.nextStates.keys.contains(null)) {
      currentNodeIndex = currentNode?.nextStates[null];
      return (position, null);
    }

    return (
      position,
      SyntacticAnalyzerException(position, "Unexpected end of the expression")
    );
  }

  (AnalyzerPosition, AnalyzerException?) nextSymbol(
      AnalyzerPosition startPosition, String code) {
    List<String> lines = code.split("\n");
    AnalyzerPosition position = startPosition;
    if (position.$2 == lines[position.$1].length) {
      return (position, null);
    }
    if (position.$1 < lines.length && position.$2 < lines[position.$1].length) {
      for (String? pattern in currentNode?.nextStates.keys ?? []) {
        if (pattern == null) continue;
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
      SyntacticAnalyzerException(
        position,
        "Unexpected character '${lines[position.$1][position.$2]}', next state undefined",
      )
    );
  }
}
