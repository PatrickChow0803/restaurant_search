import 'package:flutter/material.dart';
import 'package:restaurant_search/src/client.dart';
import 'package:restaurant_search/src/search_screen.dart';

class RestaurantSearchApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(
        title: 'Restaurant App',
        dio: dio,
      ),
    );
  }
}
