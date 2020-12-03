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
                  Wrap(
                    // The spacing between the childen
                    spacing: 10,
                    children: List<Widget>.generate(10, (index) {
                      final isSelected = index % 2 == 0;
                      return FilterChip(
                        label: Text('Category $index'),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyText1.color,
                        ),
                        selected: isSelected,
                        checkmarkColor: Colors.white,
                        onSelected: (bool selected) {},
                      );
                    }),
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
