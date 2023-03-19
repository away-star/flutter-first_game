import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final _inputController = StreamController.broadcast();
  final _scoreController = StreamController.broadcast();


  //一次改进代码(使用StreamController的监听)
  // num score = 0;
  //
  // @override
  // void initState() {
  //   _scoreController.stream.listen((score) {
  //     setState(() {
  //       this.score += score;
  //     });
  //   });
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //二次改进代码
        title: Center(
          child: StreamBuilder(
              stream: _scoreController.stream.transform(TallyTransformer()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("Score: ${snapshot.data}");
                }
                return const Text("Score: 0");
              }),
        ),

        //一次改进代码(使用StreamController的监听)
        //title: Center(child: Text("Score: $score")),


        //初始代码
        // title: Center(
        //   child: StreamBuilder(
        //       stream: _scoreController.stream,
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData&&snapshot.data!=null) {
        //           score+=snapshot.data;
        //         }
        //         return Text("Score: $score");
        //       }),
        // ),
      ),
      body: Stack(children: [
        //此处使用...将list展开成为一个个child widget
        ...List.generate(
            2,
            (index) => Puzzle(
                  inputStream: _inputController.stream,
                  scoreStream: _scoreController,
                )),
        // Puzzle(inputStream: _controller.stream,),
        Align(
            alignment: Alignment.bottomCenter,
            child: KeyPad(controller: _inputController)),
      ]),
    );
  }
}

class TallyTransformer implements StreamTransformer {
  num sum = 0;
  StreamController _controller = StreamController();

  @override
  Stream bind(Stream stream) {
    stream.listen((event) {
      sum += event;
      _controller.add(sum);
    });
    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() => StreamTransformer.castFrom(this);
}

class KeyPad extends StatelessWidget {
  // const KeyPad({Key? key}) : super(key: key);

  //将上面的_controller传给这个widget
  final StreamController controller;

  const KeyPad({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(0.0),
      //让它不占满整个屏幕
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 2 / 1,
      children: List.generate(9, (index) {
        return ElevatedButton(
          //调整按键的颜色
          style: ButtonStyle(
            //调整按钮颜色
            backgroundColor:
                MaterialStateProperty.all(Colors.primaries[index][200]),
            //让按钮的圆角消失
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0))),
          ),
          onPressed: () {
            controller.add(index + 1);
          },
          child: Text(
            'Item ${index + 1}',
            style: Theme.of(context).textTheme.headline5,
          ),
        );
      }),
    );
  }
}

class Puzzle extends StatefulWidget {
  //const Puzzle(this.inputStream,{Key? key}) : super(key: key);

  final inputStream;
  final scoreStream;

  const Puzzle(
      {super.key, required this.inputStream, required this.scoreStream});

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> with SingleTickerProviderStateMixin {
  late int a, b;

  late Color color;

  late double x;

  late AnimationController _controller;
  late Duration duration;

  @override
  void initState() {
    //对动画controller进行初始化
    _controller = AnimationController(
      vsync: this,
    ); //..repeat(reverse: true);
    //先初始化_controller再对里面的duration进行初始化
    reset(Random().nextDouble() * 0.2);

    //监听动画播放结束的事件
    _controller.addStatusListener((status) {
      // print(widget.inputStream);
      if (status == AnimationStatus.completed) {
        reset();
        //未答对 添加-3事件
        widget.scoreStream.add(-3);
      }
    });

    //监听用户输入的stream
    widget.inputStream.listen((input) {
      if (input == a + b) {
        reset();
        //答对了 添加 5事件
        widget.scoreStream.add(5);
      }
    });
    super.initState();
  }

  //采用参数默认值 []
  void reset([from = 0.0]) {
    a = Random().nextInt(5) + 1;
    b = Random().nextInt(5);
    x = Random().nextDouble() * 300;
    _controller.duration = Duration(milliseconds: Random().nextInt(800) + 4000);
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)][200]!;
    _controller.forward(from: from);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Positioned(
          //此处减去100是为了让动画的位置自然一点（不会自动消失）
          top: MediaQuery.of(context).size.height / 1.3 * _controller.value -
              100,
          left: x,
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.blue[300]!),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text("$a + $b", style: const TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }
}
