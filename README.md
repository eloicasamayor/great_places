# great_places

A Flutter app with native device features.

This project was developed following a section in the ["Flutter & Dart - The Complete Guide [2021 Edition]"](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)

## Working with Files
For working with the File type, we have to import the dart.io package
```dart
import 'dart:io';
```
To create a File object, we just call **File()** and provide the path of the file

## Working with Locations
We can define a Location, for example, with a custom class that contains:
- double Latitude
- double Longitude
- String Adress

## Opening the camera and taking a picture
We can use the package [image_picker](https://pub.dev/packages/image_picker)
```dart
import 'package:image_picker/image_picker.dart';
```
And just call picker.getImage() in an async function
```dart
File _storedImage;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _storedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
```

## Store the image
- The [path_provider package](https://pub.dev/packages/path_provider) helps us to find the OS path where to save the data
- and the [path package](https://pub.dev/packages/path) helps us to combining paths.

## Store the data in a local DB
We can use SQLite as it is suported in Android and iOS, for this project we use the [sqflite](https://pub.dev/packages/sqflite) package.
- sqflite.getDatabasesPath(): returns the folder in the device where to store the db.
- sqflite.openDatabase(): returns a handle to the database. we provide:
  - the complete path to the db (path + db name)
  - onCreate: a function that will run if sqflite tries to open the db and doesn't find the file. Sqflite gives the function two arguments: the db and the version, and in the body we can tell sqflite to create the DB and return the resulting Future.
  - version: the num verion of the db.
- sqlDb.insert() method for inserting data to the db.
Of course **the map passed as the data argument have to match the SQL schema of the table we want to affect**.
```dart
static Future<void> insert(String table, Map<String, Object> data) async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDb = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT');
      },
      version: 1,
    );
    await sqlDb.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }
```

## Show a map preview image
We can use the [Google Maps Static API](https://developers.google.com/maps/documentation/maps-static) to get an image of a map giving a location. It's a paid service, but there is a free tier under certain usage.
To get it, we only have to configure the google cloud account, get the API_KEY, and we get an url image that can depend on the location.
```dart
  static String generateLocationPreviewImage(
      {double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
```
Then, we siply use this url in an Image.Network() widget.

## Render a dinamic Google Maps
We can use the official [Google Maps Flutter package](https://pub.dev/packages/google_maps_flutter/install)

## Sets
Sets in dart are like lists but the **items cannot be repeated**. We define sets between curly braces (like maps)