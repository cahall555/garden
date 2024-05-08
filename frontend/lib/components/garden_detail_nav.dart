import 'package:flutter/material.dart';
import '../model/garden.dart';
import '../view/garden_detail.dart';
import '../view/garden_create.dart';
import '../view/garden_update.dart';
import '../view/plant_create.dart';
import '../provider/plant_provider.dart';
import '../provider/garden_provider.dart';
import '../view/tags_list.dart';

class GardenDetailNavigation extends StatefulWidget {
	final Garden garden;
  const GardenDetailNavigation({super.key, required this.garden});

  @override
  State<GardenDetailNavigation> createState() => _GardenDetailNavigationState();
}

class _GardenDetailNavigationState extends State<GardenDetailNavigation> {
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
        backgroundColor: Color(0XFF8E505F),
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.local_florist_rounded),
            icon: Icon(Icons.local_florist_rounded, color: Colors.white),
            label: 'Garden Detail',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.mode_edit_rounded),
            icon: Icon(Icons.mode_edit_rounded, color: Colors.white),
            label: 'Update Garden',
          ),
    //      NavigationDestination(
      //      selectedIcon: Icon(Icons.delete_rounded),
        //    icon: Icon(Icons.delete_rounded, color: Colors.white),
          //  label: 'Delete Garden',
         // ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_rounded),
            icon: Icon(Icons.add_rounded, color: Colors.white),
            label: 'Add Plant',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bar_chart_rounded),
            icon: Icon(Icons.bar_chart_rounded, color: Colors.white),
            label: 'Chart',
          ),
        ],
      ),
      body: <Widget>[
        GardenDetail(garden: widget.garden),
        GardenUpdate(garden: widget.garden),
//	onPressed:() {Provider.of<GardenProvider>(context, listen: false)
  //                    .deleteGarden(garden.id)};
        PlantCreate(garden: widget.garden),
        TagList(),
      ][_currentPageIndex],
    );
  }
}
