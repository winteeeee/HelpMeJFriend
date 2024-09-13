import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double width;
  final double height;

  const Loading({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: const CircularProgressIndicator(),
    );
  }
}