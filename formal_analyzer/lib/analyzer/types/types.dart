import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';

typedef AnalyzerPosition = (int, int);
typedef AnalyzerInformation = (
  AnalyzerPosition,
  AnalyzerException?,
  AnalyzerResult?
);
typedef AnalysisTransitionFunction = (AnalyzerPosition, AnalyzerException?)
    Function(AnalyzerPosition position, String code);
typedef AnalysisSemanticFunction = AnalyzerException? Function(
    AnalyzerPosition position, AnalyzerResult result);

abstract class Analyzer {
  late AnalysisSemanticFunction? semanticAction;
  Analyzer([this.semanticAction]);

  AnalyzerInformation analyze(String code, AnalyzerPosition startPosition);
  (AnalyzerException?, AnalyzerResult?) beginAnalyze(String code) {
    AnalyzerInformation analyzeInfo = analyze(code, (0, 0));
    return (analyzeInfo.$2, analyzeInfo.$3);
  }
}
