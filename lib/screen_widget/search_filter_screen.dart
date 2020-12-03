import 'package:flutter/material.dart';

class SearchFilterScreen extends StatefulWidget {
  @override
  _SearchFilterScreen createState() => _SearchFilterScreen();
}

class _SearchFilterScreen extends State<SearchFilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter your search'),
      ),
      backgroundColor: Colors.red,
      body: Text('Filter your search'),
    );
  }
}
