import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  String result = '';

  void _onButtonPressed(String value) {
    setState(() {
      _controller.text += value;
    });
  }

  void _addDecimal() {
    setState(() {
      if (!_controller.text.contains('.')) {
        _controller.text += '.';
      }
    });
  }

  void _clearInput() {
    setState(() {
      _controller.clear();
      result = '';
    });
  }

  void _toggleSign() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        double currentValue = double.tryParse(_controller.text) ?? 0;
        _controller.text = (currentValue * -1).toString();
      }
    });
  }

  void _calculatePercentage() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        double currentValue = double.tryParse(_controller.text) ?? 0;
        _controller.text = (currentValue / 100).toString();
      }
    });
  }

  void _evaluateExpression() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_controller.text);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        result = eval.toString();
      });
    } catch (e) {
      setState(() {
        result = 'Error';
      });
    }
  }

  void _backspace() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _controller.text =
            _controller.text.substring(0, _controller.text.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> buttons = [
      'AC',
      '+/-',
      '%',
      '÷',
      '7',
      '8',
      '9',
      '×',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '↺',
      '0',
      '.',
      '='
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter numbers',
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              result,
              style: const TextStyle(
                  fontSize: 26, color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: 2.0,
                ),
                itemCount: buttons.length,
                itemBuilder: (context, index) {
                  String buttonText = buttons[index];
                  Color buttonColor;
                  Color fontColor = Colors.white;

                  switch (buttonText) {
                    case 'AC':
                    case '+/-':
                    case '%':
                      buttonColor = const Color.fromARGB(255, 0, 0, 0);
                      fontColor = const Color.fromARGB(255, 3, 255, 234);
                      break;
                    case '÷':
                    case '×':
                    case '-':
                    case '+':
                      buttonColor = const Color.fromARGB(255, 0, 0, 0);
                      fontColor = Colors.red;
                      break;
                    case '=':
                      buttonColor = const Color.fromARGB(255, 0, 0, 0);
                      fontColor = Colors.red;
                      break;
                    case '↺':
                      buttonColor = const Color.fromARGB(255, 0, 0, 0);
                      break;
                    default:
                      buttonColor = const Color.fromARGB(255, 0, 0, 0);
                      fontColor = Colors.white;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (buttonText == 'AC') {
                          _clearInput();
                        } else if (buttonText == '=') {
                          _evaluateExpression();
                        } else if (buttonText == '+/-') {
                          _toggleSign();
                        } else if (buttonText == '%') {
                          _calculatePercentage();
                        } else if (buttonText == '.') {
                          _addDecimal();
                        } else if (buttonText == '↺') {
                          _backspace();
                        } else if (buttonText == '÷') {
                          _onButtonPressed('/');
                        } else if (buttonText == '×') {
                          _onButtonPressed('*');
                        } else {
                          _onButtonPressed(buttonText);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        textStyle: TextStyle(fontSize: 18, color: fontColor),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: fontColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
