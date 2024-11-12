import 'package:formal_analyzer/analyzer/analyzers/keyword.dart';
import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

class SemanticAnalyzer {
  String prettyCode = "";
  Set<String> constants = {};
  Set<String> identifiers = {};

  static AnalyzerException? skip(
          AnalyzerPosition position, AnalyzerResult result) =>
      null;

  AnalyzerException? add(AnalyzerPosition position, AnalyzerResult result) {
    prettyCode += "${result.recognizedPattern.toUpperCase()} ";
    return null;
  }

  AnalyzerException? constant(
      AnalyzerPosition position, AnalyzerResult result) {
    String constant = result.recognizedPattern;
    if (!constant.contains(".")) {
      int? integerConstant = int.tryParse(constant);
      if (integerConstant == null) {
        return SemanticAnalyzerException(
            position,
            "An integer constant was expected, but the substring could not"
            " be converted to an integer and parsed");
      } else if (integerConstant > 32768 || integerConstant < -32768) {
        return SemanticAnalyzerException(
            position,
            "The integer constant must be in the range between -32768 and 32768,"
            " but the value obtained is $integerConstant");
      }
    }
    constants.add(constant);
    prettyCode += "$constant ";
    return null;
  }

  AnalyzerException? identifier(
      AnalyzerPosition position, AnalyzerResult result) {
    String identifier = result.recognizedPattern.toUpperCase();
    if (identifier.length > 8) {
      return SemanticAnalyzerException(
        position,
        "The identifier must be no longer than 8 characters",
      );
    } else if (Keyword.values
        .map((keyword) => keyword.name)
        .contains(identifier)) {
      return SemanticAnalyzerException(
        position,
        "The identifier cannot match keyword. Reserved keywords:"
        " ${Keyword.values.map((keyword) => keyword.name)}",
      );
    }
    identifiers.add(identifier);
    prettyCode += "$identifier ";
    return null;
  }
}
