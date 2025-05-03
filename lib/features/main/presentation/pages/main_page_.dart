import 'package:flutter/material.dart'
    show StatelessWidget, Widget, Scaffold, Colors, BuildContext;

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: child,
    );
  }
}
