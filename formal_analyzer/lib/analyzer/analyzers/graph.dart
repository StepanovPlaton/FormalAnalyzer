import 'package:formal_analyzer/analyzer/graph.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

class GraphAnalyzer implements Analyzer {
  final AnalyzerGraph graph;
  const GraphAnalyzer(this.graph);

  @override
  AnalyzerInformation analyze(
      AnalyzerPosition startPosition, String code, AnalyzerResult result) {
    AnalyzerPosition position = startPosition;
    while (graph.currentNode != null) {
      var (stepPosition, stepException, stepResult) =
          graph.currentNode!.analyzer.analyze(position, code, result);
      position = stepPosition;
      if (stepResult != null) result = stepResult;
      if (stepException != null) return (position, stepException, result);

      var (nextPosition, nextException) = graph.next(position, code, result);
      position = nextPosition;
      if (nextException != null) return (position, nextException, result);
    }
    result.endOf(graph.saveToListOf);
    graph.currentNodeIndex = 0;
    return (position, null, result);
  }
}
