import 'package:formal_analyzer/analyzer/exceptions.dart';
import 'package:formal_analyzer/analyzer/types.dart';

class SymbolAnalyzer {
  const SymbolAnalyzer();
  SymbolAnalyzerInformation analyze(
      AnalyzerPosition position, String code, String substring) {
    List<String> lines = code.split("\n");
    String codeLine = lines[position.$1];
    return (
      (position.$1, position.$2 + 1),
      null,
      substring + codeLine[position.$2]
    );
  }
}

class RegExpAnalyzer implements SymbolAnalyzer {
  final String regExp;
  const RegExpAnalyzer(this.regExp);

  @override
  SymbolAnalyzerInformation analyze(
      AnalyzerPosition position, String code, String substring) {
    List<String> lines = code.split("\n");
    String codeLine = lines[position.$1];
    int linePosition = position.$2;
    if (codeLine[position.$2].contains(RegExp(regExp))) {
      return (
        (position.$1, position.$2 + 1),
        null,
        substring + codeLine[position.$2]
      );
    } else {
      return (
        (position.$1, linePosition),
        AnalyzerException((
          position.$1,
          linePosition
        ), "Symbol of the form $regExp was expected, but ${codeLine[position.$2]} was received",
            ExceptionType.syntactic),
        substring
      );
    }
  }
}
