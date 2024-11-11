import 'package:formal_analyzer/analyzer/types/state.dart';

class AnalyzerResult {
  String prettyCode = "";
  Set<String> identifiers = {};
  Set<String> constants = {};
  bool successComplete = false;
  String recognizedPattern = "";

  AnalyzerResult.empty();
  AnalyzerResult.keyword(this.prettyCode);
  AnalyzerResult(this.prettyCode, this.identifiers, this.constants);

  AnalyzerResult add(AnalyzerResult result) {
    prettyCode += result.prettyCode;
    identifiers.addAll(result.identifiers);
    constants.addAll(constants);
    recognizedPattern += result.recognizedPattern;
    if (result.successComplete) successComplete = true;
    return this;
  }

  void endOf(Save typeOfRecognizedPattern) {
    if(recognizedPattern == "") return;
    prettyCode += "${recognizedPattern.toUpperCase()} ";
    if (typeOfRecognizedPattern == Save.constant) {
      constants.add(recognizedPattern);
    } else if (typeOfRecognizedPattern == Save.identifier) {
      identifiers.add(recognizedPattern);
    }
    recognizedPattern = "";
  }
}
