import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class HomePage extends StatefulWidget {
  final AdvancedDrawerController advancedDrawerController;

  const HomePage({required this.advancedDrawerController});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Advanced Drawer Example'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
            ],
          ),
          leading: IconButton(
            onPressed: widget.advancedDrawerController.showDrawer,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: widget.advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 1'),
                    subtitle: Text('Subtitle 1.'),
                  ),
                ],
              ),
            ),
            Card(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),                    ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 2'),
                    subtitle: Text('Subtitle 2'),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.album),
                    title: Text('Hello 3'),
                    subtitle: Text('Subtitle 3'),
                  ),
                ],
              ),
            ),
          ],
        )
      );
    }
}