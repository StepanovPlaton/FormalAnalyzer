import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/graph.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

class GraphAnalyzer extends Analyzer {
  final AnalyzerGraph graph;
  GraphAnalyzer(this.graph, [super.semanticAction]);

  @override
  AnalyzerInformation analyze(String code, AnalyzerPosition startPosition) {
    AnalyzerPosition position = startPosition;
    AnalyzerResult result = AnalyzerResult.empty();
    while (graph.currentNode != null) {
      var (stepPosition, stepException, stepResult) =
          graph.currentNode!.analyzer.analyze(code, position);
      position = stepPosition;
      if (stepResult != null) result.add(stepResult);
      if (stepException != null) {
        result.log(stepException.message);
        return (position, stepException, result);
      }

      result.log(
          "Find next state (transition by ${graph.transition == GraphTransition.toWord ? "word" : "symbol"})");
      var (nextPosition, nextException) = graph.next(position, code);
      position = nextPosition;
      if (nextException != null) {
        result.log(nextException.message);
        return (position, nextException, result);
      }
    }
    if (semanticAction != null) {
      AnalyzerException? semanticException = semanticAction!((position.$1, position.$2-1), result);
      if (semanticException != null) {
        result.log(semanticException.message);
        return (position, semanticException, result);
      }
    }
    graph.currentNodeIndex = 0;
    return (position, null, result);
  }
}
