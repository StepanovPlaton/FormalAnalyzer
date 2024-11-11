import 'package:formal_analyzer/analyzer/states.dart';
import 'package:formal_analyzer/analyzer/types/exceptions.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

abstract class Analyzer {
  AnalyzerInformation analyze(
      AnalyzerPosition startPosition, String code, AnalyzerResult result);
}

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

class RegExpAnalyzer implements Analyzer {
  late String regExp;
  late bool save;
  RegExpAnalyzer(this.regExp) {
    save = true;
  }
  RegExpAnalyzer.spaces() {
    regExp = "";
    save = false;
  }

  @override
  AnalyzerInformation analyze(
      AnalyzerPosition position, String code, AnalyzerResult result) {
    List<String> lines = code.split("\n");
    String codeLine = lines[position.$1];
    int linePosition = position.$2;
    if(regExp == ""){
      return (position, null, result);
    }
    if (codeLine[position.$2].contains(RegExp(regExp))) {
      if (save) {
        result.recognizedPattern += codeLine[position.$2];
      }
      return ((position.$1, position.$2 + 1), null, result);
    } else {
      return (
        (position.$1, linePosition),
        AnalyzerException((
          position.$1,
          linePosition
        ), "Symbol of the form $regExp was expected, but '${codeLine[position.$2]}' was received",
            ExceptionType.syntactic),
        result
      );
    }
  }
}
