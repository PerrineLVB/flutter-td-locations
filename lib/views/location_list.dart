import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/colors.dart';
import 'package:location/models/location.dart';
import 'package:location/services/habitation_service.dart';
import 'package:location/services/location_service.dart';
import 'package:location/views/share/bottom_navigation_bar_widget.dart';

class LocationListArgument {
  final String routeNameNext;

  LocationListArgument(this.routeNameNext);
}

class LocationList extends StatefulWidget {
  static String routeName = '/locations';
  final String routeNameNext;
  const LocationList(this.routeNameNext, {super.key});

  @override
  State<LocationList> createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  final LocationService service = LocationService();
  late Future<List<Location>> _locations;

  @override
  void initState() {
    super.initState();
    _locations = service.getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Locations'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _locations,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) =>
                    _buildRow(snapshot.data![index], context),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(2),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'fr_FR').format(date);
  }

  _buildRow(Location location, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Column(children: [
        SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: (Card(
            child: Column(
              children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListTile(
                          title: Text(HabitationService()
                              .getHabitationDetailsById(location.idhabitation)
                              .libelle),
                          subtitle: Text(HabitationService()
                              .getHabitationDetailsById(location.idhabitation)
                              .adresse),
                        ),
                        Text('${location.montanttotal} €',
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(children: [
                            const Icon(
                              Icons.calendar_today,
                              color: darkBlue,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              _formatDate(location.dateDebut),
                              style: const TextStyle(
                                  color: darkBlue, fontSize: 18),
                            ),
                          ]),
                        ),
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: darkBlue,
                          child: Icon(
                            Icons.arrow_right_alt,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: darkBlue,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                _formatDate(location.dateFin),
                                style: const TextStyle(
                                    color: darkBlue, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    location.facture != null
                        ? 'Facture délivrée le ${_formatDate(location.facture!.date)}'
                        : 'Aucune facture',
                  )
                ])
              ],
            ),
          )),
        )
      ]),
    );
  }
}
