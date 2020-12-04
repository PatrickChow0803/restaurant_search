import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
//                  print(key);
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
