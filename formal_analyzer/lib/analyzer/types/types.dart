import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';

typedef AnalyzerPosition = (int, int);
typedef AnalyzerInformation = (
  AnalyzerPosition,
  AnalyzerException?,
  AnalyzerResult?
);
typedef AnalysisTransitionFunction = (AnalyzerPosition, AnalyzerException?)
    Function(AnalyzerPosition position, String code, AnalyzerResult result);
typedef AnalysisSemanticFunction = AnalyzerException? Function(
    AnalyzerPosition position, AnalyzerResult result);

abstract class Analyzer {
  final AnalysisSemanticFunction semanticAction;
  Analyzer(this.semanticAction);

  AnalyzerInformation analyze(
      AnalyzerPosition startPosition, String code);
}
