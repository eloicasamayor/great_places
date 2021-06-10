# great_places

A Flutter app with native device features.

This project was developed following a section in the ["Flutter & Dart - The Complete Guide [2021 Edition]"](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)

> Note: this projects is using a protected Google Maps API key. You should change the API key it in case you want to run it.

## Working with Files
For working with the File type, we have to import the dart.io package
```dart
import 'dart:io';
```
To create a File object, we just call **File()** and provide the path of the file

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
## Store files in the device
- The [path_provider package](https://pub.dev/packages/path_provider) helps us to find the OS path where to save the data.
- and the [path package](https://pub.dev/packages/path) helps us to combining paths.
```dart
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

//imageFile.path -> temporary directory
final appDir = await syspaths.getApplicationDocumentsDirectory();
final fileName = path.basename(imageFile.path);
final savedImage = await imageFile.copy('${appDir.path}/${fileName}');
```

## using a local DB: SQLite
We can use SQLite as it is suported in Android and iOS, for this project we use the [sqflite](https://pub.dev/packages/sqflite) package.
```dart
import 'package:sqflite/sqflite.dart' as sql;
```
**sql.getDatabasesPath()**: returns the folder in the device where to store the db.
**sql.openDatabase()**: returns a handle to the database. we provide:
- the complete path to the db (path + db name)
- onCreate: a function that will run if sqflite tries to open the db and doesn't find the file. Sqflite gives the function two arguments: the db and the version, and in the body we can tell sqflite to create the DB and return the resulting Future.
- version: the num verion of the db.
```dart
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
      },
      version: 1,
    );
  }
```
**db.insert()** method for inserting data to the db.
Of course **the map passed as the data argument have to match the SQL schema of the table we want to affect**.
```dart
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }
```
**db.query()**: method to data grom the db.

```dart
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }
```
## Show a map preview image
To get the device current location we can use the [location package](https://pub.dev/packages/location). getLocation() method returns the location data.
```dart
import 'package:location/location.dart';
final locData = await Location().getLocation();
````
Then, we can use the [Google Maps Static API](https://developers.google.com/maps/documentation/maps-static) to get an image of a map giving a location. It's a paid service, but there is a free tier under certain usage.
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
There is a GoogleMap widget, we might provide
- a initialCameraPosition with the target LatLng(lat,lng) and the zoom
- an onTap function (it gets the LatLng of the tap)
- a list of Markers
```dart
GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 18,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation,
                )
              },
      ),
```