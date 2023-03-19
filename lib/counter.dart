import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count=0;

  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Countter(value: _count, duration: const Duration(seconds: 3),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Countter extends StatelessWidget {
  final int value;
  final Duration duration;


  Countter({
    super.key,this.value=0, required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 120,
      child: TweenAnimationBuilder(
        tween: Tween<double>(end:value.toDouble()),
        duration:duration,
        builder: (BuildContext context, value, Widget? child) {
          //除了后只取整数
          print("$value~/1");
          final whole= value ~/ 1;
          final decimal =value -whole;

          return Stack(children: [
            Positioned(
              top: -100*decimal,
              child: Opacity(
                opacity: 1-decimal,
                child: Text(
                  "$whole",
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
            Positioned(
              top: 100-decimal*100,
              child: Opacity(
                opacity: decimal,
                child: Text(
                  "${whole+1}",
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
