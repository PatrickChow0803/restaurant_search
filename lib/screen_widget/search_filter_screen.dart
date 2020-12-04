import 'package:flutter/material.dart';
import 'package:restaurant_search/main.dart';
import 'package:restaurant_search/model/category.dart';
import 'package:restaurant_search/model/search_options.dart';

class SearchFilterScreen extends StatefulWidget {
  // These are the options that can be used for filtering from the API
  final locations = ['city', 'subzone', 'zone', 'landmark', 'metro', 'group'];
  final sort = ['cost', 'rating'];
  final order = ['asc', 'desc'];

  @override
  _SearchFilterScreen createState() => _SearchFilterScreen();
}

class _SearchFilterScreen extends State<SearchFilterScreen> {
  List<Category> _categories;

  SearchOptions _searchOptions;

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
    // Setting location here so that there's a default option selected
    _searchOptions = SearchOptions(location: widget.locations.first);

//    _searchOptions = SearchOptions();
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
                            final isSelected = _searchOptions.categories.contains(category.id);
                            return FilterChip(
                              label: Text(category.name),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).textTheme.bodyText1.color,
                              ),
                              selected: isSelected,
                              showCheckmark: false,
                              selectedColor: Colors.orange,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected)
                                    _searchOptions.categories.add(category.id);
                                  else {
                                    _searchOptions.categories.remove(category.id);
                                  }
                                });
                              },
                            );
                          }),
                        )
                      : Center(child: CircularProgressIndicator()),
                  SizedBox(height: 30),
                  Text('Location Type',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _searchOptions.location,
                    items: widget.locations
                        .map<DropdownMenuItem<String>>((location) => DropdownMenuItem<String>(
                              value: location,
                              child: Text(location),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _searchOptions.location = value;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  Text('Order By', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  // For look to determine how many RadioListTiles should exist
                  for (int idx = 0; idx < widget.order.length; idx++)
                    RadioListTile(
                      title: Text(widget.order[idx]),
                      value: widget.order[idx],
                      groupValue: _searchOptions.order,
                      onChanged: (selection) {
                        setState(() {
                          _searchOptions.order = selection;
                        });
                      },
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
