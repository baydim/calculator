import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";

  TextEditingController red = TextEditingController();

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        red.text = equation;
        result = "0";
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        red.text = equation;
        if (equation == "") {
          equation = "0";
          red.text = equation;
        }
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
          red.text = equation;
        } else {
          equation = equation + buttonText;
          red.text = equation;
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      margin: EdgeInsets.all(3),
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(20)),
      child: TextButton(
          // padding: EdgeInsets.all(16.0),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 1.3,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(15),
                child:
                    // TextField(
                    //   keyboardType: TextInputType.multiline,
                    //   style: TextStyle(fontSize: equationFontSize),
                    //   readOnly: true,
                    //   controller: red,
                    // ),
                    SingleChildScrollView(
                  child: Text(
                    equation,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // Expanded(
            //   child: Divider(),
            // ),
            Positioned(
              bottom: 5,
              left: 5,
              right: 5,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Text(
                      result,
                      style: TextStyle(fontSize: 48),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * .70,
                        child: Table(
                          children: [
                            TableRow(children: [
                              buildButton("C", 1, Colors.redAccent),
                              buildButton("⌫", 1, Colors.blue),
                              buildButton("÷", 1, Colors.blue),
                            ]),
                            TableRow(children: [
                              buildButton("7", 1, Colors.black54),
                              buildButton("8", 1, Colors.black54),
                              buildButton("9", 1, Colors.black54),
                            ]),
                            TableRow(children: [
                              buildButton("4", 1, Colors.black54),
                              buildButton("5", 1, Colors.black54),
                              buildButton("6", 1, Colors.black54),
                            ]),
                            TableRow(children: [
                              buildButton("1", 1, Colors.black54),
                              buildButton("2", 1, Colors.black54),
                              buildButton("3", 1, Colors.black54),
                            ]),
                            TableRow(children: [
                              buildButton(".", 1, Colors.black54),
                              buildButton("0", 1, Colors.black54),
                              buildButton("00", 1, Colors.black54),
                            ]),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Table(
                          children: [
                            TableRow(children: [
                              buildButton("×", 1, Colors.blue),
                            ]),
                            TableRow(children: [
                              buildButton("-", 1, Colors.blue),
                            ]),
                            TableRow(children: [
                              buildButton("+", 1, Colors.blue),
                            ]),
                            TableRow(children: [
                              buildButton("=", 2, Colors.redAccent),
                            ]),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
