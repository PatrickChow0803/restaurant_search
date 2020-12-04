import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_search/src/app_state.dart';
import 'package:restaurant_search/src/restaurant_serach_app.dart';
import 'package:restaurant_search/src/search_screen.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MultiProvider(
    // Create is the data that you want to pass down the widget tree
    providers: [
      Provider(create: (context) => ZomatoApi()),
      Provider(create: (context) => AppState()),
    ],

    // This is the topmost widget that will have the data inside of the create: parameter
    child: RestaurantSearchApp(),
  ));
}
