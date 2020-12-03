import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:restaurant_search/model/restaurant.dart';
import 'package:restaurant_search/screen_widget/restaurant_item.dart';
import 'package:restaurant_search/screen_widget/search_filter_screen.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(RestaurantSearchApp());
}

// Look at https://developers.zomato.com/documentation#!/restaurant for documentation reference
final dio = Dio(BaseOptions(
    baseUrl: 'https://developers.zomato.com/api/v2.1/',
    headers: {'user-key': DotEnv().env['ZOMATO_API_KEY']}));

class RestaurantSearchApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(title: 'Restaurant App'),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  String query;

  Future<List> searchRestaurants(String query) async {
    // pass in an empty string here because the BaseOptions already has the baseUrl
    final response = await dio.get('search', queryParameters: {
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
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchFilterScreen()));
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

class SearchForm extends StatefulWidget {
  final void Function(String search) onSearch;

  const SearchForm({Key key, this.onSearch}) : super(key: key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  var _autoValidate = AutovalidateMode.onUserInteraction;
  var _search;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        // without this automalidateMode, the 'Please enter a search term' messages wouldn't appear
        autovalidateMode: _autoValidate,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Enter Search',
                  border: OutlineInputBorder(),
                  filled: true,
                  errorStyle: TextStyle(fontSize: 15)),
              // value is the callback's value that is given when the validator triggers
              validator: (value) {
                if (value.isEmpty) {
                  return ('Please enter a search term');
                }
                if (value == 'a') {
                  return ('test');
                }
                return null;
              },
              // value is the callback's value that is given when the text changes
              onChanged: (value) {
                _search = value;
              },
            ),
            SizedBox(height: 10.0),
            Container(
              height: 50,
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () async {
                  String key = DotEnv().env['ZOMATO_API_KEY'];
                  print(key);
                  final isValid = _formKey.currentState.validate();
                  if (isValid) {
                    widget.onSearch(_search);
                    // Gets rid of the soft keyboard after clicking on the button, either way work
//                    FocusScope.of(context).requestFocus(new FocusNode());
                    FocusManager.instance.primaryFocus.unfocus();
                  } else {
//                          setState(() {
//                            _autoValidate = AutovalidateMode.always;
//                          });
                  }
                },
                fillColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
