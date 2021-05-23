import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicorum/connector/misc.dart';
import 'package:musicorum/constants/colors.dart';
import 'package:musicorum/constants/common.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

const listTileTitleStyle = const TextStyle(fontWeight: FontWeight.w500);
const contentPadding = const EdgeInsets.symmetric();

class _SettingsPageState extends State<SettingsPage> {
  String version = '';

  @override
  void initState() {
    super.initState();

    _fetchStuff();
  }

  _fetchStuff() async {
    version = await MiscConnections.getVersionString();
    setState(() {});
    print(version);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                SettingsFragment(title: 'About', items: [
                  ListTile(
                    title: Text(
                      'App version',
                      style: listTileTitleStyle,
                    ),
                    subtitle: Text(version),
                    contentPadding: contentPadding,
                  ),
                  ListTile(
                    title: Text(
                      'Github repository',
                      style: listTileTitleStyle,
                    ),
                    subtitle: Text('Click to open in a new page'),
                    contentPadding: contentPadding,
                  )
                ])
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SettingsFragment extends StatelessWidget {
  SettingsFragment({@required this.title, @required this.items});

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: LIST_PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: MUSICORUM_LIGHT),
              ),
              ...items,
            ],
          ),
        ),
        Divider(color: SURFACE_SECONDARY_COLOR,)
      ],
    );
  }
}
