import 'package:flutter/material.dart';
import 'package:musicorum/components/title.dart';

class ScrobblingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScrobblingPageState();
  }
}

class ScrobblingPageState extends State<ScrobblingPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [PageTitle('Scrobbling')],
    );
  }
}