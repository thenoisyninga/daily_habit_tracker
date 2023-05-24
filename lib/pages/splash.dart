import 'package:daily_habit_tracker/pages/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late Animation<double> _borderRadiusOuterAnimation;
  late Animation<double> _borderRadiusInnerAnimation;
  late Animation<double> _scaleInnerAnimation;

  @override
  void initState() {
    super.initState();

    // initialize controller
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _controller1.forward();
    });

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // border radius animation
    _borderRadiusOuterAnimation =
        Tween(begin: 10.0, end: 100.0).animate(CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeInOut,
      // reverseCurve: Curves.easeIn,
    ));

    _borderRadiusInnerAnimation =
        Tween(begin: 5.0, end: 100.0).animate(CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeInOut,
    ));

    _scaleInnerAnimation = Tween(begin: 30.0, end: -20.0)
        .animate(CurvedAnimation(parent: _controller2, curve: Curves.easeIn));

    _controller1.addListener(() {
      setState(() {});
    });

    _controller2.addListener(() {
      setState(() {});
    });

    int count = 0;

    _controller1.addStatusListener((status) {
      if (count <= 1) {
        if (status == AnimationStatus.completed) {
          count++;
          Future.delayed(Duration(milliseconds: count == 2 ? 1000 : 0), () {
            _controller1.reverse();
          });
        } else if (status == AnimationStatus.dismissed) {
          _controller1.forward();
        }
      } else {
        Future.delayed(const Duration(seconds: 0), () {
          _controller2.forward();
        });
      }
    });

    _controller2.addStatusListener((status) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
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
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(_borderRadiusOuterAnimation.value),
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
                  borderRadius:
                      BorderRadius.circular(_borderRadiusInnerAnimation.value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
