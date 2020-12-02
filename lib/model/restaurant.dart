class Restaurant {
  final String id;
  final String name;
  final String address;
  final String locality;
  final String rating;
  final int reviews;
  final String thumbnail;

  Restaurant._(
      {this.id, this.name, this.address, this.locality, this.rating, this.reviews, this.thumbnail});

  // https://developers.zomato.com/api/v2.1/search?q=Pizza
  // Type that into PostMan for reference

  factory Restaurant(Map json) => Restaurant._(
      id: json['restaurant']['id'],
      name: json['restaurant']['name'],
      address: json['restaurant']['location']['address'],
      locality: json['restaurant']['location']['locality'],
      rating: json['restaurant']['user_rating']['aggregate_rating']?.toString(),
      reviews: json['restaurant']['all_reviews_count'],
      thumbnail: json['restaurant']['featured_image'] ?? 'https://placehold.it/100x100');
}
