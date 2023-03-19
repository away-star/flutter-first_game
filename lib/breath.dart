import 'package:flutter/material.dart';

class Braeth extends StatefulWidget {
  const Braeth({Key? key}) : super(key: key);

  @override
  State<Braeth> createState() => _BraethState();
}

class _BraethState extends State<Braeth> with TickerProviderStateMixin {

   late AnimationController _controller;
   late AnimationController _opacityController;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,

    );
    _opacityController = AnimationController(
      vsync: this,

    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: const Text("Braeth")),
        ),
        body: Center(
          child: FadeTransition(
            opacity: Tween(begin: 1.0, end: 0.7).animate(_opacityController),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.blue,
                        Colors.blue[200]!,
                        Colors.blue[100]!,
                        Colors.blue[50]!,
                      ],
                      //下面为什么报错
                      //stops: const [_controller.value, 0.6, 0.9, 1.0],

                      stops: [
                        _controller.value,
                        _controller.value + 0.1,
                        _controller.value + 0.3,
                        _controller.value + 0.5
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue,
                      Colors.blue[200]!,
                      Colors.blue[100]!,
                      Colors.blue[50]!,
                    ],
                    stops: const [0.5, 0.6, 0.9, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //设置_controller的动画
            _controller.duration = const Duration(seconds: 4);
            _controller.forward();
            await Future.delayed(const Duration(seconds: 4));

            //设置_opacityController的动画
            _opacityController.duration = const Duration(milliseconds: 1750);
            _opacityController.repeat(reverse: true);
            await Future.delayed(const Duration(milliseconds: 7000));
            _opacityController.reset();

            //设置_controller的动画
            _controller.duration = const Duration(seconds: 8);
            _controller.reverse();
          },
          child: const Icon(Icons.play_arrow),
        ));
  }
}
