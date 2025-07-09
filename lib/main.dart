import 'package:flutter/material.dart';
import 'package:sarcasm_nb_detector/sarcasm_detector.dart';

void main() {
  runApp(SarcasmApp());
}

class SarcasmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sarcasm Detector',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: SarcasmHomePage(),
    );
  }
}

class SarcasmHomePage extends StatefulWidget {
  @override
  _SarcasmHomePageState createState() => _SarcasmHomePageState();
}

class _SarcasmHomePageState extends State<SarcasmHomePage> {
  final TextEditingController _controller = TextEditingController();
  String result = '';
  bool isButtonEnabled = false;

  late SarcasmDetector detector;


  @override
  void initState() {
    super.initState();
    detector = SarcasmDetector();
    detector.loadModel('assets/naive_bayes_model.json');
    _controller.addListener(() {
      setState(() {
        isButtonEnabled = _controller.text.trim().isNotEmpty;
      });
    });
  }


  void _checkSarcasm() async {
    final inputText = _controller.text;
    final isSarcastic = await detector.isSarcastic(inputText);
    setState(() {
      result = isSarcastic ? "Sarcasm Detected 🫠" : "No Sarcasm Detector 😒";
    });
  }

  void _clearSarcasm() async {
    var inputText = _controller.text;
    final isSarcastic = await detector.isSarcastic(inputText);
    setState(() {
      result = isSarcastic ? "Please Enter Something to Predict☝️️" : "";
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sarcasm Detector',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter text',
                labelStyle: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16.0),
           child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Expanded(
              child:ElevatedButton(
                onPressed: isButtonEnabled ? _checkSarcasm : null,
                child: Text('Check Sarcasm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                     color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              ),
              SizedBox(width: 15),
              Expanded(
              child: ElevatedButton(
                onPressed: _clearSarcasm,
                child: Text('Clear TextField',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ),
             ],
            ),
        ),
            SizedBox(height: 16),
            Text(
              result,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}


