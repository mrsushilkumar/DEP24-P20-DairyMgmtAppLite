import 'dart:async';

import 'package:farm_expense_mangement_app/screens/home/homepage.dart';
import 'package:farm_expense_mangement_app/screens/home/profilepage.dart';
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
  final int _screenFromNumber = 0;
  int _selectedIndex = 0; // Add this variable to track selected index

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

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        _appBar = const HomeAppBar();
        _bodyScreen = const HomePage() as PreferredSizeWidget;
      } else {
        _appBar = const ProfileAppBar();
        _bodyScreen = const ProfilePage() as PreferredSizeWidget;
      }
    });
  }

  void home(BuildContext context) {
    setState(() {
      _updateIndex(0); // Update index when home is pressed
    });
  }

  void profile(BuildContext context) {
    setState(() {
      _updateIndex(1); // Update index when profile is pressed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: _appBar,
      body: _bodyScreen,
      bottomNavigationBar: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        child: BottomAppBar(
          shadowColor: Colors.white70,
          color: const Color.fromRGBO(13, 166, 186, 1.0),
          surfaceTintColor: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  profile(context);
                },
                backgroundColor: _selectedIndex == 1
                    ? Colors.black
                    : const Color.fromRGBO(13, 166, 186, 1.0),
                elevation: 0,
                child: const Icon(
                  Icons.person,
                  color: Colors.white70,
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  home(context);
                },
                backgroundColor: _selectedIndex == 0
                    ? Colors.black
                    : const Color.fromRGBO(13, 166, 186, 1.0),
                elevation: 0,
                child: const Icon(
                  Icons.home,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
