import 'package:flutter/material.dart';
import 'package:restaurant_search/main.dart';
import 'package:restaurant_search/model/category.dart';

class SearchFilterScreen extends StatefulWidget {
  @override
  _SearchFilterScreen createState() => _SearchFilterScreen();
}

class _SearchFilterScreen extends State<SearchFilterScreen> {
  List<Category> _categories;

  // Type is int because _categories.id is an int
  // Therefore this _selectedCategories contains a list of category ids
  List<int> _selectedCategories = [];

  // https://developers.zomato.com/api/v2.1/categories
  // Look at the above for reference, might also want to look up the dio instance below
  Future<List<Category>> getCategories() async {
    final response = await dio.get('categories');
    final data = response.data['categories'];

    // Map data's data into a new Category object for each object inside of data.
    return data
        .map<Category>((json) => Category(
              id: json['categories']['id'],
              name: json['categories']['name'],
            ))
        .toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Once you retrieved the categories, call setState since the UI is changing.
    // I know that .then((categories) is a List of categories because that's the return type of getCategories()
    // The return type is also no longer a Future because .then is called.
    getCategories().then((categories) {
      setState(() {
        _categories = categories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter your search'),
      ),
      body: Container(
        // For scrolling functionality
        child: ListView(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  // Because you have to wait for _categories to get it's value from an async method,
                  // use this check to display a loading indicator until _categories is initialized
                  _categories is List<Category>
                      ? Wrap(
                          // The spacing between the childen
                          spacing: 10,
                          children: List<Widget>.generate(_categories.length, (index) {
                            final category = _categories[index];
                            final isSelected = _selectedCategories.contains(category.id);
                            return FilterChip(
                              label: Text(category.name),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).textTheme.bodyText1.color,
                              ),
                              selected: isSelected,
                              checkmarkColor: Colors.white,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected)
                                    _selectedCategories.add(category.id);
                                  else {
                                    _selectedCategories.remove(category.id);
                                  }
                                });
                              },
                            );
                          }),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * .70,
//                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
