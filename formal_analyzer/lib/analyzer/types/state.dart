import 'package:formal_analyzer/analyzer/analyzer.dart';

class GraphNode {
  final String name;
  final Analyzer analyzer;
  final Map<String?, int?> nextStates;
  const GraphNode(this.name, this.analyzer, this.nextStates);
}

enum TypeOfTransition {
  word,
  symbol
}
enum Save {
  identifier,
  constant,
  noSave
}

class Graph {
  final List<GraphNode> states;
  int? currentNodeIndex = 0;

  GraphNode? get currentNode {
    if (currentNodeIndex != null) {
      return states[currentNodeIndex!];
    } else {
      return null;
    }
  }

  Graph(this.states);
}