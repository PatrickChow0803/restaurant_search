import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_search/src/restaurant_item.dart';
import 'package:restaurant_search/src/search_filters_screen.dart';
import 'package:restaurant_search/src/search_form.dart';

import '../main.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title, this.dio}) : super(key: key);
  final Dio dio;

  final String title;

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  String query;

  Future<List> searchRestaurants(String query) async {
    // pass in an empty string here because the BaseOptions already has the baseUrl
    final response = await widget.dio.get('search', queryParameters: {
      'q': query,
      'sort': 'rating',
    });
    print(response);
    return response.data['restaurants'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchFilterScreen(dio: widget.dio)));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.tune),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SearchForm(onSearch: (q) {
              setState(() {
                query = q;
              });
            }),
            query == null
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 110,
                          color: Colors.black12,
                        ),
                        Text(
                          'No results to display',
                          style: TextStyle(
                            color: Colors.black12,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : FutureBuilder(
                    future: searchRestaurants(query),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Expanded(child: Center(child: CircularProgressIndicator()));
                      }
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              final restaurant = Restaurant(snapshot.data[index]);
                              return RestaurantItem(restaurant: restaurant);
                            },
                          ),
                        );
                      }
                      return Text('Error retriving results: ${snapshot.error}');
                    },
                  )
          ],
        ),
      ),
    );
  }
}
