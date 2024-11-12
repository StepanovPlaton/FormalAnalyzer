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

class KeywordsAnalyzer implements Analyzer {
  final Keyword keyword;
  @override
  final AnalysisSemanticFunction semanticAction;
  const KeywordsAnalyzer(this.keyword, this.semanticAction);

  @override
  AnalyzerInformation analyze(AnalyzerPosition position, String code) {
    List<String> lines = code.split("\n");
    String codeLine = lines[position.$1];
    int linePosition = position.$2;
    String recognizedPattern = "";
    while (linePosition < codeLine.length &&
        keyword.name.contains(codeLine[linePosition])) {
      recognizedPattern += codeLine[linePosition];
      linePosition++;
    }
    if (recognizedPattern == keyword.name) {
      AnalyzerResult result = AnalyzerResult(keyword.pretty);
      AnalyzerException? semanticException =
          semanticAction((position.$1, linePosition), result);
      return (
        (position.$1, linePosition),
        semanticException,
        AnalyzerResult(keyword.pretty)
      );
    } else {
      return (
        (position.$1, linePosition),
        SyntacticAnalyzerException(
          (position.$1, linePosition),
          "${keyword.name} was expected, but only '${recognizedPattern + codeLine[linePosition]}' was detected",
        ),
        null
      );
    }
  }
}
