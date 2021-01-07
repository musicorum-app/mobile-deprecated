import 'package:flutter/material.dart';
import 'package:musicorum/components/title.dart';

class ChartsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChartsPageState();
  }
}

class ChartsPageState extends State<ChartsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [PageTitle('Charts')],
    );
  }
}