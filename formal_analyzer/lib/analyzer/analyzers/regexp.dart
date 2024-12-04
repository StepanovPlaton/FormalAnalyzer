import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

class RegExpAnalyzer extends Analyzer {
  final String regExp;
  RegExpAnalyzer(this.regExp, [super.semanticAction]);

  @override
  AnalyzerInformation analyze(String code, AnalyzerPosition startPosition) {
    List<String> lines = code.split("\n");
    String codeLine = lines[startPosition.$1];
    AnalyzerResult result = AnalyzerResult.empty();
    if (regExp == "") {
      return (startPosition, null, null);
    }
    if (codeLine[startPosition.$2].toUpperCase().contains(RegExp(regExp))) {
      result.add(AnalyzerResult(codeLine[startPosition.$2]));
      result.log(
          "The '${codeLine[startPosition.$2]}' character matching expression '$regExp' was found");
      AnalyzerException? semanticException;
      if (semanticAction != null) {
        semanticException =
            semanticAction!(startPosition, result);
      }
      return (
        (startPosition.$1, startPosition.$2 + 1),
        semanticException,
        result
      );
    } else {
      SyntacticAnalyzerException exception = SyntacticAnalyzerException(
        startPosition,
        "Symbol of the form '$regExp' was expected, but '${codeLine[startPosition.$2]}' was received",
      );
      result.log(exception.message);
      return (startPosition, exception, result);
    }
  }
}
