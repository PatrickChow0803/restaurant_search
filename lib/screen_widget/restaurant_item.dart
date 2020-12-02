import 'package:flutter/material.dart';
import 'package:restaurant_search/model/restaurant.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantItem({Key key, this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          restaurant.thumbnail != null && restaurant.thumbnail.isNotEmpty
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
