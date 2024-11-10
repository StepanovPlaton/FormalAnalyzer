class AnalyzerResult {
  String prettyCode = "";
  Set<String> identifiers = {};
  Set<String> constants = {};
  bool successComplete = false;

  AnalyzerResult.empty();
  AnalyzerResult.keyword(this.prettyCode);
  AnalyzerResult(this.prettyCode, this.identifiers, this.constants);

  AnalyzerResult add(AnalyzerResult result) {
    prettyCode += result.prettyCode;
    identifiers.addAll(result.identifiers);
    constants.addAll(result.constants);
    if(result.successComplete) successComplete = true;
    return this;
  }
}
