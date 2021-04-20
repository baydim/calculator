import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent, // status bar color
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
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
      margin: EdgeInsets.all(7),
      height: MediaQuery.of(context).size.height * 0.09 * buttonHeight,
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
                color: buttonText == "C" || buttonText == "="
                    ? Colors.white
                    : Colors.black54),
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
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.3,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(15),
                  color: Colors.transparent,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      equation,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
            ),

            // Expanded(
            //   child: Divider(),
            // ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
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
                  Container(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    color: Colors.grey.withOpacity(0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .70,
                          child: Table(
                            children: [
                              TableRow(children: [
                                buildButton("C", 1, Colors.redAccent),
                                buildButton("⌫", 1, Colors.white),
                                buildButton("÷", 1, Colors.white),
                              ]),
                              TableRow(children: [
                                buildButton("7", 1, Colors.white),
                                buildButton("8", 1, Colors.white),
                                buildButton("9", 1, Colors.white),
                              ]),
                              TableRow(children: [
                                buildButton("4", 1, Colors.white),
                                buildButton("5", 1, Colors.white),
                                buildButton("6", 1, Colors.white),
                              ]),
                              TableRow(children: [
                                buildButton("1", 1, Colors.white),
                                buildButton("2", 1, Colors.white),
                                buildButton("3", 1, Colors.white),
                              ]),
                              TableRow(children: [
                                buildButton(".", 1, Colors.white),
                                buildButton("0", 1, Colors.white),
                                buildButton("00", 1, Colors.white),
                              ]),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.23,
                          child: Table(
                            children: [
                              TableRow(children: [
                                buildButton("×", 1, Colors.white),
                              ]),
                              TableRow(children: [
                                buildButton("-", 1, Colors.white),
                              ]),
                              TableRow(children: [
                                buildButton("+", 1, Colors.white),
                              ]),
                              TableRow(children: [
                                buildButton("=", 2.2, Colors.redAccent),
                              ]),
                            ],
                          ),
                        )
                      ],
                    ),
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
