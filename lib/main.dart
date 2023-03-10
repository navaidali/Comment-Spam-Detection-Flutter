import 'package:flutter/material.dart';
import 'package:fpy_ml_test/classifier.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController _controller;
  late Classifier _classifier;
  late List<Widget> _children;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _classifier = Classifier();
    _children = [];
    _children.add(Container());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: const Text('Spam Detection'),
        ),
        body: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                    itemCount: _children.length,
                    itemBuilder: (_, index) {
                      return _children[index];
                    },
                  )),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal)),
                child: Row(children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'Write some text here'),
                      controller: _controller,
                    ),
                  ),
                  TextButton(
                    child: const Text('Classify'),
                    onPressed: () {
                      final text = _controller.text;
                      final prediction = _classifier.classify(text);
                      if(prediction==1){
                        setState(() {
                          _children.add(Dismissible(
                            key: GlobalKey(),
                            onDismissed: (direction) {},
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Input: $text",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text("Output:"),
                                    Text("   Spam Detected?: $prediction"),
                                  ],
                                ),
                              ),
                            ),
                          ));
                          _controller.clear();
                        });
                      }else{
                        print("Spam not detected.");
                      }

                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}