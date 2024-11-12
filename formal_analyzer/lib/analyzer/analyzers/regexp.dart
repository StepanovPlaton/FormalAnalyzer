import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

class RegExpAnalyzer implements Analyzer {
  late String regExp;
  late bool save;
  RegExpAnalyzer(this.regExp) {
    save = true;
  }
  RegExpAnalyzer.spaces() {
    regExp = "";
    save = false;
  }

  @override
  AnalyzerInformation analyze(
      AnalyzerPosition position, String code, AnalyzerResult result) {
    List<String> lines = code.split("\n");
    String codeLine = lines[position.$1];
    int linePosition = position.$2;
    if (regExp == "") {
      return (position, null, result);
    }
    if (codeLine[position.$2].contains(RegExp(regExp))) {
      if (save) {
        result.recognizedPattern += codeLine[position.$2];
      }
      return ((position.$1, position.$2 + 1), null, result);
    } else {
      return (
        (position.$1, linePosition),
        AnalyzerException((
          position.$1,
          linePosition
        ), "Symbol of the form $regExp was expected, but '${codeLine[position.$2]}' was received",
            AnalyzerExceptionType.syntactic),
        result
      );
    }
  }
}
