import 'package:flutter/services.dart';
//Import tflite_flutter;
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  // name of the model file
  final _modelFile = 'model.tflite';
  final _vocabFile = 'vocab.txt';

  // Maximum length of sentence
  final int _sentenceLen = 256;

  final String start = '<START>';
  final String pad = '<PAD>';
  final String unk = '<UNKNOWN>';

  Map<String, int>? _dict;

  // TensorFlow Lite Interpreter object
  Interpreter? _interpreter;

  Classifier() {
    // Load model when the classifier is initialized.
    _loadModel();
    _loadDictionary();
  }

  void _loadModel() async {
    // Creating the interpreter using Interpreter.fromAsset
    _interpreter = await Interpreter.fromAsset(_modelFile);
    print('Interpreter loaded successfully');
  }

  void _loadDictionary() async {
    final vocab = await rootBundle.loadString('assets/$_vocabFile');
    var dict = <String, int>{};
    final vocabList = vocab.split('\n');
    for (var i = 0; i < vocabList.length; i++) {
      var entry = vocabList[i].trim().split(' ');
      dict[entry[0]] = i;
    }
    _dict = dict;
    print('Dictionary loaded successfully');
  }

  int classify(String rawText) {
    // tokenizeInputText returns List<List<double>>
    // of shape [1, 256].
    List<List<int>> input = tokenizeInputText(rawText);

    // output of shape [1,2].
    var output = List<double>.filled(2,0).reshape([1, 2]);

    // The run method will run inference and
    // store the resulting values in output.
    _interpreter!.run(input, output);

    var result = 1;
    // If value of first element in output is greater than second,
    // then sentence is negative
    print(output[0][1]);
    if (output[0][1] > 0.8) {
      result = 1;
    } else {
      result = 0;
    }
    return result;
  }

  List<List<int>> tokenizeInputText(String text) {
    // Whitespace tokenization
    final toks = text.split(' ');

    // Create a list of length==_sentenceLen filled with the value <pad>
    var vec = List<int>.filled(_sentenceLen, _dict![pad]!.toInt());

    var index = 0;
    if (_dict!.containsKey(start)) {
      vec[index++] = _dict![start]!.toInt();
    }

    // For each word in sentence find corresponding index in dict
    for (var tok in toks) {
      if (index > _sentenceLen) {
        break;
      }
      vec[index++] = _dict!.containsKey(tok)
          ? _dict![tok]!.toInt()
          : _dict![unk]!.toInt();
    }

    // returning List<List<double>> as our interpreter input tensor expects the shape, [1,256]
    return [vec];
  }
}