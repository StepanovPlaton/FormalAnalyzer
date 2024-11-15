class AnalyzerResult {
  List<String> analysisLog = [];
  String recognizedPattern = "";

  AnalyzerResult.empty();
  AnalyzerResult(this.recognizedPattern);

  AnalyzerResult add(AnalyzerResult result) {
    recognizedPattern += result.recognizedPattern;
    analysisLog.addAll(result.analysisLog);
    return this;
  }
  void log(String message) => analysisLog.add(message);
}
