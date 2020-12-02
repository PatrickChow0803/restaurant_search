class Restaurant {
  final String name;
  final String address;
  final String rating;
  final int reviews;

  Restaurant(Map<String, dynamic> json)
      : name = json['restaurant']['name'],
        address = json['restaurant']['location']['address'],
        rating = json['restaurant']['user_rating']['aggregate_rating'],
        reviews = json['restaurant']['all_reviews_count'];
}
