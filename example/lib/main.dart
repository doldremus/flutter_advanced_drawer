import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_advanced_drawer_example/drawer.dart';
import 'package:flutter_advanced_drawer_example/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.blueGrey,
      controller: _advancedDrawerController,
      drawerSlideRatio: 1,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 250),
      animateChildDecoration: true,
      childAnimationDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: HomePage(advancedDrawerController: _advancedDrawerController),
      drawer: DrawerWidget()
    );
  }
}
