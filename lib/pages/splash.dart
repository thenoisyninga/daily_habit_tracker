import 'package:flutter/material.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late Animation<double> _borderRadiusOuterInitialAnimation;
  late Animation<double> _borderRadiusOuterFinalAnimation;
  late Animation<double> _borderRadiusInnerInitialAnimation;
  late Animation<double> _borderRadiusInnerFinalAnimation;
  late Animation<double> _scaleInnerAnimation;

  double _borderRadiusInside = 0;
  double _borderRadiusOutside = 0;

  @override
  void initState() {
    super.initState();

    // initialize controller for circle/square switch
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // initialize controller for make into logo
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // initialize controller for collapse on itself
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _borderRadiusInside = _borderRadiusInnerInitialAnimation.value;
      _borderRadiusOutside = _borderRadiusOuterInitialAnimation.value;
      _controller1.forward();
    });

    // animations for circle to sqaure switch
    _borderRadiusOuterInitialAnimation =
        Tween(begin: 0.0, end: 100.0).animate(CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    ));

    _borderRadiusInnerInitialAnimation =
        Tween(begin: 0.0, end: 100.0).animate(CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    ));

    // animations for square to logo switch
    _borderRadiusOuterFinalAnimation =
        Tween(begin: 100.0, end: 10.0).animate(CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    ));

    _borderRadiusInnerFinalAnimation =
        Tween(begin: 100.0, end: 5.0).animate(CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    ));

    // Animation for collapse on itself
    _scaleInnerAnimation =
        Tween(begin: 30.0, end: -10.0).animate(CurvedAnimation(
      parent: _controller3,
      curve: Curves.easeIn,
    ));

    // listeners to update values according to animation stage
    _controller1.addListener(() {
      setState(() {
        _borderRadiusInside = _borderRadiusInnerInitialAnimation.value;
        _borderRadiusOutside = _borderRadiusOuterInitialAnimation.value;
      });
    });

    _controller2.addListener(() {
      setState(() {
        _borderRadiusInside = _borderRadiusInnerFinalAnimation.value;
        _borderRadiusOutside = _borderRadiusOuterFinalAnimation.value;
      });
    });

    _controller3.addListener(() {
      setState(() {});
    });

    int count = 0;

    // inital animation (circle/square switch) loops 2 times then initiates 2nd animation (controller 2)
    _controller1.addStatusListener((status) {
      if (count == 0) {
        if (status == AnimationStatus.completed) {
          _controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          count++;
          _controller1.forward();
        }
      } else {
        Future.delayed(const Duration(milliseconds: 250), () {
          _controller2.forward();
        });
      }
    });

    // controller 2 checks if square to logo animation is complete,
    // then waits a second before starting collapse on itself
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 3), () {
          _controller3.forward();
        });
      }
    });

    _controller3.addStatusListener((status) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
          print("push home here");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: _scaleInnerAnimation.value + 20,
                width: _scaleInnerAnimation.value + 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  borderRadius: BorderRadius.circular(_borderRadiusOutside),
                ),
              ),
              Container(
                height: _scaleInnerAnimation.value < 0
                    ? 0
                    : _scaleInnerAnimation.value,
                width: _scaleInnerAnimation.value < 0
                    ? 0
                    : _scaleInnerAnimation.value,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(_borderRadiusInside),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
