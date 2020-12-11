import 'package:flutter/material.dart';
import 'package:staged_drawer/drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(body: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Scaffold(
                  body: StagedDrawer(
                    duration: Duration(milliseconds: 5000),
                    size: widgetList.length,
                    builder: (context, index) {
                      return widgetList[index];
                    },
                  ),
                ),
              ),
            );
          },
          child: Icon(
            Icons.menu,
          ),
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.lightBlueAccent,
        ),
      ),
    );
  }

  final widgetList = [
    _buildBigItem(),
    _buildSmallItem(Icons.home, 'HOME'),
    _buildSmallItem(Icons.menu, 'FEED'),
    _buildSmallItem(Icons.message, 'MESSAGES'),
    _buildSmallItem(Icons.camera_alt, 'PHOTOS'),
    _buildSmallItem(Icons.place, 'PLACES'),
    _buildSmallItem(Icons.notifications, 'NOTIFICATIONS'),
    _buildSmallItem(Icons.person, 'PROFILE'),
    _buildSmallItem(Icons.camera_alt, 'PHOTOS'),
    _buildSmallItem(Icons.place, 'PLACES'),
    _buildSmallItem(Icons.notifications, 'NOTIFICATIONS'),
    _buildSmallItem(Icons.person, 'PROFILE'),
    _buildSmallItem(Icons.camera_alt, 'PHOTOS'),
    _buildSmallItem(Icons.place, 'PLACES'),
    _buildSmallItem(Icons.notifications, 'NOTIFICATIONS'),
    _buildSmallItem(Icons.person, 'PROFILE'),
  ];

  static _buildBigItem() {
    return Center(
      child: Container(
        height: 300,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'MI',
              style: TextStyle(fontSize: 120),
            ),
          ),
        ),
      ),
    );
  }

  static _buildSmallItem(IconData icon, String text) {
    return Container(
      height: 72,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Icon(
              icon,
              size: 30,
            ),
            flex: 2,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            flex: 9,
          ),
        ],
      ),
    );
  }
}
