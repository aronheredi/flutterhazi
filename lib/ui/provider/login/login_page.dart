import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginPageProvider extends StatefulWidget {
  const LoginPageProvider({super.key});

  @override
  State<LoginPageProvider> createState() => _LoginPageProviderState();
}

class _LoginPageProviderState extends State<LoginPageProvider> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _initializePage());
  }

  //TODO: Try auto-login on model
  void _initializePage() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [const Text("Login Page")],
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
