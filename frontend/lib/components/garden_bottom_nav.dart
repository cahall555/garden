import 'package:flutter/material.dart';
import '../view/garden_list.dart';
import '../view/garden_create.dart';
import '../view/tags_list.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        backgroundColor: Color(0XFF987D3F),
        selectedIndex: _currentPageIndex,
	indicatorColor: Color(0XFFFED16A),
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Color(0XFF344E41)),
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_rounded, color: Color(0XFF344E41)),
            icon: Icon(Icons.add_rounded, color: Colors.white),
            label: 'Add Garden',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bar_chart_rounded, color: Color(0XFF344E41)),
            icon: Icon(Icons.bar_chart_rounded, color: Colors.white),
            label: 'Chart',
          ),
        ],
      ),
      body: <Widget>[
        GardenList(),
        GardenCreate(),
        TagList(),
      ][_currentPageIndex],
    );
  }
}