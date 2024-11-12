import 'package:formal_analyzer/analyzer/semantic.dart';
import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

class RegExpAnalyzer implements Analyzer {
  final String regExp;
  @override
  late AnalysisSemanticFunction semanticAction;

  RegExpAnalyzer(this.regExp) {
    semanticAction = SemanticAnalyzer.skip;
  }
  RegExpAnalyzer.withSemantic(this.regExp, this.semanticAction);

  @override
  AnalyzerInformation analyze(AnalyzerPosition position, String code) {
    List<String> lines = code.split("\n");
    String codeLine = lines[position.$1];
    if (regExp == "") {
      return (position, null, null);
    }
    if (codeLine[position.$2].contains(RegExp(regExp))) {
      AnalyzerResult result = AnalyzerResult(codeLine[position.$2]);
      AnalyzerException? semanticException =
          semanticAction((position.$1, position.$2 + 1), result);
      return ((position.$1, position.$2 + 1), semanticException, result);
    } else {
      return (
        position,
        SyntacticAnalyzerException(
          position,
          "Symbol of the form '$regExp' was expected, but '${codeLine[position.$2]}' was received",
        ),
        null
      );
    }
  }
}
