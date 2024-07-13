import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mediconnect/Pages/home_pagemain.dart';
//import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3),(){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) =>MainHomePage()));
        
    });
  }
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(25),
        child: AnimatedSplashScreen(
          splash: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      
                      height: constraints.maxHeight * 1.2, // Adjust the size based on screen height
                      child: Lottie.asset("assets/1.png"), // Replace with your animation path
                    ),
                  ],
                ),
              );
            },
          ),
          nextScreen: MainHomePage(),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}

