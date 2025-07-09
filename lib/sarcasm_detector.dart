import 'dart:convert';
import 'package:flutter/services.dart';

class SarcasmDetector {
  late Map<String, int> vocabulary;
  late List<List<double>> featureLogProb;
  late List<double> classLogPrior;
  late List<int> classes;

  Future<void> loadModel(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString);

    vocabulary = Map<String, int>.from(jsonData['vocabulary']);
    if (jsonData.containsKey('feature_log_prob') && jsonData['feature_log_prob'] != null) {
      featureLogProb = (jsonData['feature_log_prob'] as List<dynamic>)
          .map<List<double>>((row) => (row as List<dynamic>)
          .map<double>((val) => val.toDouble())
          .toList())
          .toList();
    }

    if (jsonData.containsKey('class_log_prior') && jsonData['class_log_prior'] != null) {
      classLogPrior = (jsonData['class_log_prior'] as List<dynamic>)
          .map<double>((e) => e.toDouble())
          .toList();
    }

    classes = List<int>.from(jsonData['classes']);
  }

  int predict(String inputText) {
    final tokens = inputText.toLowerCase().split(RegExp(r'\W+'));
    final inputVector = List<int>.filled(vocabulary.length, 0);

    for (var token in tokens) {
      if (vocabulary.containsKey(token)) {
        inputVector[vocabulary[token]!] = 1;
      }
    }

    final scores = List<double>.from(classLogPrior);
    for (int classIdx = 0; classIdx < classes.length; classIdx++) {
      for (int i = 0; i < inputVector.length; i++) {
        if (inputVector[i] == 1) {
          scores[classIdx] += featureLogProb[classIdx][i];
        }
      }
    }

    return classes[scores[0] > scores[1] ? 0 : 1];
  }

  Future<bool> isSarcastic(String text) async {
    final result = predict(text);
    return result == 1;
  }
}