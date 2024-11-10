import 'package:formal_analyzer/analyzer/patterns/symbol.dart';
import 'package:formal_analyzer/analyzer/result.dart';
import 'package:formal_analyzer/analyzer/types.dart';

enum IdentifierAnalyzeState {
  letter(RegExpAnalyzer("[a-zA-Z]"), {"[a-zA-Z0-9_]": 1}),
  symbol(RegExpAnalyzer("[a-zA-Z0-9_]"), {"[a-zA-Z0-9_]": 1, "[ ><=]": null});

  final SymbolAnalyzer analyzer;
  final Map<String?, int?> nextStates;
  const IdentifierAnalyzeState(this.analyzer, this.nextStates);

  IdentifierAnalyzeState? next(
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
            return IdentifierAnalyzeState.values[nextStates[pattern]!];
          } else {
            return null;
          }
        }
      }
    }
    return null;
  }
}

class IdentifierAnalyzer implements PatternAnalyzer {
  const IdentifierAnalyzer();

  @override
  AnalyzerInformation analyze(AnalyzerPosition startPosition, String code) {
    IdentifierAnalyzeState? state = IdentifierAnalyzeState.values[0];
    String identifier = "";
    AnalyzerResult result = AnalyzerResult.empty();
    AnalyzerPosition position = startPosition;
    while (state != null) {
      var (stepPosition, stepException, stepIdentifier) =
          state.analyzer.analyze(position, code, identifier);
      position = stepPosition;
      identifier = stepIdentifier;
      if (stepException != null) return (position, stepException, result);

      state = state.next(position, code);
    }
    result.identifiers.add(identifier);
    result.prettyCode+="$identifier ";
    return (position, null, result);
  }
}
