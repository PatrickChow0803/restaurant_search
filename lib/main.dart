import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(RestaurantSearchApp());
}

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
  final _formKey = GlobalKey<FormState>();

  var _autoValidate = AutovalidateMode.onUserInteraction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
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
                    // value is the callback's value that is given when the text changes
                    validator: (value) {
                      if (value.isEmpty) {
                        return ('Please enter a search term');
                      }
                      if (value == 'a') {
                        return ('test');
                      }
                      return null;
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
            )
          ],
        ),
      ),
    );
  }
}
