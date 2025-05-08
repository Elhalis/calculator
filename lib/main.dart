import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  String num1 = '';
  String num2 = '';
  String result = '';
  String operator = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none)),
              minLines: 2,
              maxLines: 4,
              textAlign: TextAlign.right, // not textdirection
            ),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ...[
                      'C',
                      '%',
                      '^',
                      '/',
                      '7',
                      '8',
                      '9',
                      '*',
                      '4',
                      '5',
                      '6',
                      '-',
                      '1',
                      '2',
                      '3',
                      '+',
                      '+/-',
                      '0',
                      '.',
                      '=',
                    ].map((btn) => ElevatedButton(
                          onPressed: () {
                            onBtnPress(btn);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text(
                            btn,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onBtnPress(String label) {
    setState(() {
      if (label == 'C') {
        num1 = '';
        num2 = '';
        operator = '';
        result = '';
      } else if (label == '/' ||
          label == '*' ||
          label == '-' ||
          label == '+' ||
          label == '%' ||
          label == '^') {
        if (num1.isEmpty) {
          num1 = _controller.text;
          operator = label;
          result = num1;
          _controller.text = '';
        } else if (_controller.text.isNotEmpty) {
          num2 = _controller.text;
          calculate();
          num1 = result;
          operator = label;
          num2 = '';
          operator = '';
        }
      } else if (label == '+/-') {
        if (_controller.text.isNotEmpty) {
          _controller.text = _controller.text.startsWith('-')
              ? _controller.text.substring(1)
              : '-${_controller.text}';
        }
      } else if (label == '.') {
        if (_controller.text.isEmpty) {
          _controller.text = '0.';
        } else if (!_controller.text.contains('.')) {
          _controller.text += '.';
        }
      } else if (label == '0') {
        if (_controller.text != '0') {
          _controller.text += label;
        }
      } else if (label == '=') {
        if (num1.isNotEmpty &&
            operator.isNotEmpty &&
            _controller.text.isNotEmpty) {
          num2 = _controller.text;
          calculate();
          _controller.text = result;
          num1 = '';
          num2 = '';
          operator = '';
        }
      } else {
        _controller.text += label;
        if (num1.isNotEmpty && operator.isNotEmpty) {
          num2 = _controller.text;
          calculate();
        }
      }
    });
  }

  void calculate() {
    double n1 = double.tryParse(num1) ?? 0;
    double n2 = double.tryParse(num2) ?? 0;
    double res = 0;

    switch (operator) {
      case '+':
        res = n1 + n2;
      case '-':
        res = n1 - n2;
      case '*':
        res = n1 * n2;
      case '%':
        res = n1 % n2;
      case '^':
        res = n1;
        for (int i = 1; i < n2; i++) {
          res *= n1;
        }
      case '/':
        if (n2 != 0) {
          res = n1 / n2;
        } else {
          result = 'can\'t divide by zero';
          return;
        }
    }
    result = res.toStringAsFixed(res % 1 == 0 ? 0 : 2);
  }
}
