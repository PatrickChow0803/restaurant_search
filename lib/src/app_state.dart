import 'package:restaurant_search/src/api.dart';
import 'package:restaurant_search/src/search_filters_screen.dart';

class AppState {
  final SearchOptions searchOptions = SearchOptions(
    location: kLocations.first,
    order: kOrder.first,
    sort: kSort.first,
    count: kCount,
  );
}
