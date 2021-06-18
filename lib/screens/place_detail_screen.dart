import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  void _deleteItem(BuildContext ctx, String id) async {
    await Provider.of<GreatPlaces>(ctx, listen: false).remove(id);
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            selectedPlace.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            child: Text(
              'View on map',
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                    initialLocation: selectedPlace.location,
                    isSelecting: false,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: SizedBox(),
          ),
          TextButton.icon(
            onPressed: () {
              _deleteItem(context, id);
            },
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 12,
                  decorationColor: Colors.white,
                ),
              ),
              padding: MaterialStateProperty.all(EdgeInsets.all(12)),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
              ),
            ),
            icon: Icon(Icons.delete),
            label: Text('Remove'),
          ),
        ],
      ),
    );
  }
}
