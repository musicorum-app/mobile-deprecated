import 'package:flutter/material.dart';

class Destination {
  const Destination(this.index, this.title, this.id, this.icon);

  final int index;
  final String id;
  final String title;
  final IconData icon;
}

const List<Destination> destinations = <Destination>[
  Destination(0, 'Home', 'home', Icons.home),
  Destination(1, 'Discover', 'discover', Icons.search),
  Destination(2, 'Scrobbling', 'scrobbling', Icons.queue_music),
  Destination(3, 'Charts', 'charts', Icons.show_chart),
  Destination(3, 'Account', 'account', Icons.person),
];