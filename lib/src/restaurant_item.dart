import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantItem({Key key, this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          restaurant.thumbnail != null && restaurant.thumbnail.isNotEmpty
              // This only displays the image that should be shown for the restaurant
              ? Ink(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      image: DecorationImage(image: NetworkImage(restaurant.thumbnail))),
                )
              : Container(
                  height: 100,
                  width: 100,
                  color: Colors.blueGrey,
                  child: Icon(Icons.restaurant, size: 30, color: Colors.white),
                ),
          // This widget prevents overflow by having the text shift to the next line if there's too much
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    // makes overflow text into triple dots
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                      ),
                      Text(restaurant.locality),
                    ],
                  ),
                  SizedBox(height: 5),
                  RatingBarIndicator(
                    rating: double.parse(restaurant.rating),
                    itemBuilder: (_, index) {
                      return Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
//    return ListTile(
//      // https://developers.zomato.com/api/v2.1/search?q=Pizza
//      // Type that into PostMan for reference
//      title: Text(restaurant.name),
//      subtitle: Text(restaurant.address),
//      trailing: Text('${restaurant.rating} Stars, '
//          '${restaurant.reviews} Reviews'),
//    );
  }
}
