# great_places

A Flutter app with native device features.

This project was developed following a section in the ["Flutter & Dart - The Complete Guide [2021 Edition]"](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)

## Working with Files
For working with the File type, we have to import the dart.io package
```dart
import 'dart:io';
```

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