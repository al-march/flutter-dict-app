import 'package:flutter/material.dart';

class AppScroll extends StatelessWidget {
  const AppScroll({
    super.key,
    this.child,
    this.padding,
    this.center = false,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final bool center;

  @override
  Widget build(BuildContext context) {
    Alignment aligment = center ? Alignment.center : Alignment.topCenter;

    return Align(
      alignment: aligment,
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [child ?? const SizedBox()],
        ),
      ),
    );
  }
}