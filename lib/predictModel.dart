import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PredModel extends StatefulWidget {
  const PredModel({Key? key}) : super(key: key);

  @override
  State<PredModel> createState() => _PredModelState();
}

class _PredModelState extends State<PredModel> {
  var predValue="hellloooo";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("click predict button to predict");
  }

  Future<void> predData() async {
    final interpreter = await Interpreter.fromAsset('model.tflite');
    var input= "si , ze does - matt ` er ; no r eally ^ fyjlxqcbp hey , my girlfriend bought me these penls pil 1 s an";
    var output=List.filled(1, 0).reshape([1,1]);
    interpreter.run(input, output);
    print(output[0]);

    this.setState(() {
      predValue =output[0].toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(),

          ElevatedButton(onPressed:()=> predData(), child: Text("Submit")),
          SizedBox(height: 30,),

          Text(predValue),
        ],
      ),),
    );
  }
}
