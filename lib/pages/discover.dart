import 'package:flutter/material.dart';
import 'package:musicorum/components/title.dart';

class DiscoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DiscoverPageState();
  }
}

class DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView(
        children: [PageTitle('Discover')],
      ),
    );
  }
}