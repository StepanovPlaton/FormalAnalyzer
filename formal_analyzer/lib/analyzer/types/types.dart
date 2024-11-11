import 'package:formal_analyzer/analyzer/types/exceptions.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';

typedef AnalyzerPosition = (int, int);
typedef AnalyzerInformation = (
  AnalyzerPosition,
  AnalyzerException?,
  AnalyzerResult?
);
typedef AnalysisFunction = AnalyzerInformation Function(
    AnalyzerPosition position, String code);
typedef AnalysisTransitionFunction = (AnalyzerPosition, AnalyzerException?) Function(
    AnalyzerPosition position, String code, AnalyzerResult result);

abstract class PatternAnalyzer {
  AnalyzerInformation analyze(AnalyzerPosition position, String code);
}
