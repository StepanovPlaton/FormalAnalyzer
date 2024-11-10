import 'package:formal_analyzer/analyzer/patterns/symbol.dart';
import 'package:formal_analyzer/analyzer/result.dart';
import 'package:formal_analyzer/analyzer/types.dart';

enum OperatorAnalyzeState {
  operator(RegExpAnalyzer("[><=]"), {null: null});

  final SymbolAnalyzer analyzer;
  final Map<String?, int?> nextStates;
  const OperatorAnalyzeState(this.analyzer, this.nextStates);

  OperatorAnalyzeState? next(
      AnalyzerPosition startPosition, String code) {
    List<String> lines = code.split("\n");
    AnalyzerPosition position = startPosition;
    if (position.$1 == lines.length &&
        position.$2 == lines[position.$1].length) {
      return null;
    } else {
      for (String? pattern in nextStates.keys) {
        if (pattern == null || lines[position.$1][position.$2].contains(RegExp(pattern))) {
          if (nextStates[pattern] != null) {
            return OperatorAnalyzeState.values[nextStates[pattern]!];
          } else {
            return null;
          }
        }
      }
    }
    return null;
  }
}

class OperatorAnalyzer implements PatternAnalyzer {
  const OperatorAnalyzer();

  @override
  AnalyzerInformation analyze(AnalyzerPosition startPosition, String code) {
    OperatorAnalyzeState? state = OperatorAnalyzeState.values[0];
    String operator = "";
    AnalyzerResult result = AnalyzerResult.empty();
    AnalyzerPosition position = startPosition;
    while (state != null) {
      var (stepPosition, stepException, stepOperator) =
          state.analyzer.analyze(position, code, operator);
      position = stepPosition;
      operator = stepOperator;
      if (stepException != null) return (position, stepException, result);

      state = state.next(position, code);
    }
    result.prettyCode+="$operator ";
    return (position, null, result);
  }
}