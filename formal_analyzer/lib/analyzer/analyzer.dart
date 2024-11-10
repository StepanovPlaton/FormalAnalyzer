import 'package:formal_analyzer/analyzer/exceptions.dart';
import 'package:formal_analyzer/analyzer/result.dart';
import 'package:formal_analyzer/analyzer/states.dart';
import 'package:formal_analyzer/analyzer/types.dart';

class Analyzer {
  AnalyzerPosition position = (0, 0);
  AnalyzerState? state = AnalyzerState.values[0];
  AnalyzerResult result = AnalyzerResult.empty();

  (AnalyzerException?, AnalyzerResult) analyze(String code) {
    while (state != null) {
      var (stepPosition, stepException, stepResult) =
          state!.analyzer.analyze(position, code);

      position = stepPosition;
      if (stepResult != null) result.add(stepResult);
      if (stepException != null) return (stepException, result);

      var (nextPosition, nextState, nextException) = state!.next(position, code);
      position = nextPosition;
      if (nextException != null) return (nextException, result);
      state = nextState;
    }
    return (null, result);
  }
}
