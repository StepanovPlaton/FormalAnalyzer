import 'package:formal_analyzer/analyzer/types/types.dart';

enum AnalyzerExceptionType { syntactic, semantic, unexpected }

class AnalyzerException {
  final AnalyzerPosition position;
  final String message;
  late AnalyzerExceptionType type = AnalyzerExceptionType.unexpected;

  AnalyzerException(this.position, this.message);

  void display() {
    print("Type: ${type.name}");
    print("Message: $message");
  }
}

class SyntacticAnalyzerException extends AnalyzerException {
  SyntacticAnalyzerException(super.position, super.message) {
    type = AnalyzerExceptionType.syntactic;
  }
}
class SemanticAnalyzerException extends AnalyzerException {
  SemanticAnalyzerException(super.position, super.message) {
    type = AnalyzerExceptionType.semantic;
  }
}