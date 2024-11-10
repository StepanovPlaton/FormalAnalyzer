import 'package:formal_analyzer/analyzer/result.dart';
import 'package:formal_analyzer/analyzer/types.dart';

class StartAnalyzer implements PatternAnalyzer {
  const StartAnalyzer();

  @override
  AnalyzerInformation analyze(AnalyzerPosition startPosition, String code) {
    List<String> lines = code.split("\n");
    AnalyzerPosition position = startPosition;
    while (position.$1 < lines.length &&
        position.$2 < lines[position.$1].length &&
        lines[position.$1][position.$2] == " ") {
      position = (position.$1, position.$2 + 1);
      if (position.$2 == lines[position.$1].length) {
        position = (position.$1 + 1, 0);
      }
    }
    AnalyzerResult result = AnalyzerResult.empty();
    if (position.$1 == lines.length &&
        position.$2 == lines[position.$1].length) {
          result.successComplete = true;
    }
    return (position, null, result);
  }
}
