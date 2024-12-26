import 'dart:math';

import 'package:flutter/material.dart';


class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("About")),
        body: SafeArea(child: _aboutBody(context)));
  }

  Widget _aboutBody(BuildContext context) {
    final textScaleFactor = min(1.4, MediaQuery.of(context).textScaleFactor);
    // Return an empty container to effectively do nothing
    return Container();
  }
}
