import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:restaurant_search/src/restaurant_serach_app.dart';
import 'package:restaurant_search/src/search_screen.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(RestaurantSearchApp());
}
