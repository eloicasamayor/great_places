import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import 'dart:io';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(
    String pickedtitle,
    File picked,
  ) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: picked,
      title: pickedtitle,
      location: null,
    );
    _items.add(newPlace);

    notifyListeners();
    DBHelper.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }
}
