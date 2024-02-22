import 'package:flutter/material.dart';
import 'package:location/models/location.dart';
import 'package:location/services/location_service.dart';
import 'package:location/views/share/bottom_navigation_bar_widget.dart';

class LocationList extends StatelessWidget {
  final LocationService service = LocationService();
  static String routeName = '/locations';
  late List<Location> _locations;
  LocationsList({Key? key}) {
    _locations = service.getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes locations'),
      ),
      body: Center(
          child: ListView.builder(
            itemCount: _locations.length,
            itemBuilder: (context, index) => _buildRow(_locations[index], context),
        )),
      bottomNavigationBar: const BottomNavigationBarWidget(1),
    );
  }

  _buildRow(Location location, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Column(
        children:[
          SizedBox (
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: (
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(location.id.toString()),
                      subtitle: Text('Dates : ${location.dateDebut} - ${location.dateFin}'),
                    ),
                  ],
                ),
              )
            ),
        )
      ]),
    );
  }
}
