
import 'package:formal_analyzer/analyzer/types.dart';

enum ExceptionType { syntactic, semantic, unexpected }

class AnalyzerException {
  AnalyzerPosition position;
  String? message = "Analyzer Exception";
  ExceptionType? type;

  AnalyzerException(this.position, this.message, this.type);

  void display() {
    print("An error has been detected!");
    print("Type: ${type!.name}");
    print("Message: $message");
  }
}
