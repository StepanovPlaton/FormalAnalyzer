// ignore_for_file: constant_identifier_names

import 'package:formal_analyzer/analyzer/types/exception.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

enum Keyword {
  IF("K "),
  THEN("K\n\t"),
  ELSIF("\nK "),
  ELSE("\nK "),
  END("K");

  final String printPattern;
  const Keyword(this.printPattern);
  String get pretty {
    return printPattern.replaceAll("K", name);
  }
}

class KeywordsAnalyzer extends Analyzer {
  final Keyword keyword;
  KeywordsAnalyzer(this.keyword, [super.semanticAction]);

  @override
  AnalyzerInformation analyze(String code, AnalyzerPosition startPosition) {
    List<String> lines = code.split("\n");
    String codeLine = lines[startPosition.$1];
    int linePosition = startPosition.$2;
    String recognizedPattern = "";
      AnalyzerResult result = AnalyzerResult.empty();
    while (linePosition < codeLine.length &&
        keyword.name.contains(codeLine[linePosition])) {
      recognizedPattern += codeLine[linePosition];
      linePosition++;
    }
    if (recognizedPattern == keyword.name) {
      result.add(AnalyzerResult(keyword.pretty));
      result.log("Found keyword ${keyword.name}");
      AnalyzerException? semanticException;
      if (semanticAction != null) {
        semanticException =
            semanticAction!((startPosition.$1, linePosition), result);
        if (semanticException != null) result.log(semanticException.message);
      }
      return (
        (startPosition.$1, linePosition),
        semanticException,
        result
      );
    } else {
      SyntacticAnalyzerException exception = SyntacticAnalyzerException(
          (startPosition.$1, linePosition),
          "${keyword.name} was expected, but only '${recognizedPattern + codeLine[linePosition]}' was detected",
        );
      result.log(exception.message);
      return (
        (startPosition.$1, linePosition),
        exception,
        result
      );
    }
  }
}
