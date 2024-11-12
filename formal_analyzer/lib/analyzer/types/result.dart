class AnalyzerResult {
  String recognizedPattern = "";

  AnalyzerResult.empty();
  AnalyzerResult(this.recognizedPattern);

  AnalyzerResult add(AnalyzerResult result) {
    recognizedPattern += result.recognizedPattern;
    return this;
  }
}
