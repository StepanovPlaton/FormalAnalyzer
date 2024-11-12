import 'package:formal_analyzer/analyzer/types/types.dart';

enum AnalyzerExceptionType { syntactic, semantic, unexpected }

class AnalyzerException {
  final AnalyzerPosition position;
  final String message;
  final AnalyzerExceptionType? type;

  AnalyzerException(this.position, this.message, this.type);

  void display() {
    print("Type: ${type!.name}");
    print("Message: $message");
  }
}
