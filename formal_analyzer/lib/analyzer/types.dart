
import 'package:formal_analyzer/analyzer/exceptions.dart';
import 'package:formal_analyzer/analyzer/result.dart';

typedef AnalyzerPosition = (int, int);
typedef AnalyzerInformation = (AnalyzerPosition, AnalyzerException?, AnalyzerResult?);
typedef AnalysisFunction = AnalyzerInformation Function(AnalyzerPosition position, String code);

abstract class PatternAnalyzer {
  AnalyzerInformation analyze(AnalyzerPosition position, String code);
} 



typedef SymbolAnalyzerInformation = (AnalyzerPosition, AnalyzerException?, String);

