import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/graph.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

class GraphAnalyzer implements Analyzer {
  final AnalyzerGraph graph;
  @override
  final AnalysisSemanticFunction semanticAction;
  const GraphAnalyzer(this.graph, this.semanticAction);

  @override
  AnalyzerInformation analyze(
      AnalyzerPosition startPosition, String code) {
    AnalyzerPosition position = startPosition;
    AnalyzerResult result = AnalyzerResult.empty();
    while (graph.currentNode != null) {
      var (stepPosition, stepException, stepResult) =
          graph.currentNode!.analyzer.analyze(position, code);
      position = stepPosition;
      if (stepResult != null) result.add(stepResult);
      if (stepException != null) return (position, stepException, result);

      var (nextPosition, nextException) = graph.next(position, code, result);
      position = nextPosition;
      if (nextException != null) return (position, nextException, result);
    }
    AnalyzerException? semanticException = semanticAction(position, result);
    if (semanticException != null) return (position, semanticException, result);
    graph.currentNodeIndex = 0;
    return (position, null, result);
  }
}
