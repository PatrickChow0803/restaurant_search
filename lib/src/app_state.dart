import 'package:restaurant_search/src/api.dart';
import 'package:restaurant_search/src/search_filters_screen.dart';

class AppState {
  final SearchOptions searchOptions = SearchOptions(
    location: kLocations.first,
    order: kOrder.first,
    sort: kSort.first,
    count: kMaxCount,
  );
}

class ZomatoApi {
  final List<String> locations = kLocations;
  final List<String> sort = kSort;
  final List<String> order = kOrder;
  final double count = kMaxCount;
}
