import 'package:formal_analyzer/analyzer/types/exceptions.dart';
import 'package:formal_analyzer/analyzer/types/result.dart';
import 'package:formal_analyzer/analyzer/types/types.dart';

enum Keyword { IF, THEN, ELSIF, ELSE, END }

extension PrettyKeywords on Keyword {
  String get pretty {
    String pretty = "";
    if (this == Keyword.THEN) {
      pretty += "$name\n\t";
    } else if (this == Keyword.ELSIF || this == Keyword.ELSE) {
      pretty += "\n$name ";
    } else if (this == Keyword.END) {
      pretty += name;
    } else {
      pretty += "$name ";
    }
    return pretty;
  }
}

class KeywordsAnalyzer implements Analyzer {
  final Keyword keyword;
  const KeywordsAnalyzer(this.keyword);

  @override
  AnalyzerInformation analyze(
      AnalyzerPosition position, String code, AnalyzerResult result) {
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
        result.add(AnalyzerResult.keyword(keyword.pretty))
      );
    } else {
      return (
        (position.$1, linePosition),
        AnalyzerException((
          position.$1,
          linePosition
        ), "${keyword.name} was expected, but only '${recognizedPattern + codeLine[linePosition]}' was detected",
            AnalyzerExceptionType.syntactic),
        result
      );
    }
  }
}
