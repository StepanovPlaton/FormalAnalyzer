import 'package:formal_analyzer/analyzer/exceptions.dart';
import 'package:formal_analyzer/analyzer/patterns/identifier.dart';
import 'package:formal_analyzer/analyzer/patterns/keywords.dart';
import 'package:formal_analyzer/analyzer/patterns/operator.dart';
import 'package:formal_analyzer/analyzer/patterns/start.dart';
import 'package:formal_analyzer/analyzer/types.dart';

enum AnalyzerState {
  start(StartAnalyzer(), {"I": 1}),
  IF(KeywordsAnalyzer(Keyword.IF), {"[a-zA-Z]": 2}),
  conditionalLeftOperand(IdentifierAnalyzer(), {" T": 5, null: 3}),
  conditionalOperator(OperatorAnalyzer(), {null: 4}),
  conditionalRightOperand(IdentifierAnalyzer(), {" T": 5}),
  THEN(KeywordsAnalyzer(Keyword.THEN), {null: null});

  final PatternAnalyzer analyzer;
  final Map<String?, int?> nextStates;
  const AnalyzerState(this.analyzer, this.nextStates);

  (AnalyzerPosition, AnalyzerState?, AnalyzerException?) next(
      AnalyzerPosition startPosition, String code) {
    List<String> lines = code.split("\n");
    AnalyzerPosition position = startPosition;
    String substring = "";
    while (
        position.$1 < lines.length && position.$2 < lines[position.$1].length) {
      substring += lines[position.$1][position.$2];
      if (lines[position.$1][position.$2] != " ") break;

      position = (position.$1, position.$2 + 1);
      if (position.$2 == lines[position.$1].length) {
        position = (position.$1 + 1, 0);
      }
    }
    if (position.$1 == lines.length &&
        position.$2 == lines[position.$1].length) {
      return (
        position,
        null,
        AnalyzerException(position, "Unexpected end of the expression",
            ExceptionType.syntactic)
      );
    } else {
      for (String? pattern in nextStates.keys) {
        if (pattern == null || substring.contains(RegExp(pattern))) {
          if (nextStates[pattern] != null) {
            return (position, AnalyzerState.values[nextStates[pattern]!], null);
          } else {
            return (position, null, null);
          }
        }
      }
    }

    return (
      position,
      null,
      AnalyzerException(
          position,
          "Unexpected character ${lines[position.$1][position.$2]}, the next state is unknown",
          ExceptionType.syntactic)
    );
  }
}
