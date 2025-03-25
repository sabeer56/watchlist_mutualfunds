import 'package:flutter/material.dart';

class PracticeScreen extends StatefulWidget{
  @override
State<PracticeScreen> createState()=> PracticeScreenApp();
}

class PracticeScreenApp extends State<PracticeScreen> {
   @override
   Widget build(BuildContext context) {
       return Scaffold(
        backgroundColor: Colors.amber,
        body:ClipPath(
          clipper: WaveClipper(),
        child: Container(
          height: 200,
          color: Colors.blue,
        ),  
        )
       );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 50);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 100, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}