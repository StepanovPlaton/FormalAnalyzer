import 'dart:math';

import 'package:formal_analyzer/analyzer/types/types.dart';

enum AnalyzerExceptionType { syntactic, semantic, unexpected }

class AnalyzerException {
  final AnalyzerPosition position;
  final String message;
  late AnalyzerExceptionType type = AnalyzerExceptionType.unexpected;

  AnalyzerException(this.position, this.message);

  String toFormattedString(String code) {
    String codeLine = code.split("\n")[position.$1];
    int start = max(0, position.$2 - 15);
    int end = min(position.$2 + 15, codeLine.length - 1);
    return "${type.name[0].toUpperCase()}${type.name.substring(1)} exception!\n"
        "Exception message: $message\n"
        "Exception position: ${position.$1 + 1} line, ${position.$2 + 1} symbol\n\n"
        "Look for mistake here:\n"
        "${position.$1 + 1}: ${start == 0 ? "" : "(...) "}${codeLine.substring(start, end + 1)}${end == codeLine.length - 1 ? "" : " (...)"}\n"
        "${" " * ((position.$1 + 1).toString().length + position.$2 - start + 2 + (start == 0 ? 0 : 6))}^";
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
