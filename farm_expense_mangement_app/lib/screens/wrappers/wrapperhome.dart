import 'dart:async';

import 'package:farm_expense_mangement_app/screens/home/homepage.dart';
import 'package:flutter/material.dart';

class WrapperHomePage extends StatefulWidget {
  const WrapperHomePage({
    super.key,
  });

  @override
  State<WrapperHomePage> createState() => _WrapperHomePageState();
}

class _WrapperHomePageState extends State<WrapperHomePage> {
  late StreamController<int> _streamControllerScreen;
  final int _screenFromNumber = 0;// Add this variable to track selected index

  late PreferredSizeWidget _appBar;
  late PreferredSizeWidget _bodyScreen;

  @override
  void dispose() {
    _streamControllerScreen.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _streamControllerScreen = StreamController<int>.broadcast();
    _streamControllerScreen.add(_screenFromNumber);
    _appBar = const HomeAppBar();
    _bodyScreen = const HomePage() as PreferredSizeWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: _appBar,
      body: _bodyScreen,
    );
  }
}
