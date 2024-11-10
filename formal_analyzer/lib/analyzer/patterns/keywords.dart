import 'package:formal_analyzer/analyzer/exceptions.dart';
import 'package:formal_analyzer/analyzer/result.dart';
import 'package:formal_analyzer/analyzer/types.dart';

enum Keyword {
  IF, THEN, ELSIF, ELSE, END
}

extension PrettyKeywords on Keyword {
  String get pretty {
    String pretty = name;
    if (this == Keyword.THEN) {
      pretty += "\n";
    } else {
      pretty += " ";
    }
    return pretty;
  }
}

class KeywordsAnalyzer implements PatternAnalyzer {
  final Keyword keyword;
  const KeywordsAnalyzer(this.keyword);

  @override
  AnalyzerInformation analyze(
      AnalyzerPosition position, String code) {
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
      return (
        (position.$1, linePosition),
        null,
        AnalyzerResult.keyword(keyword.pretty)
      );
    } else {
      return (
        (position.$1, linePosition),
        AnalyzerException((
          position.$1,
          linePosition
        ), "${keyword.name} was expected, but only ${recognizedPattern+codeLine[linePosition]} was detected",
            ExceptionType.syntactic),
        null
      );
    }
  }
}
