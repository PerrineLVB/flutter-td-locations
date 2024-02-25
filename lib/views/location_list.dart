import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/colors.dart';
import 'package:location/models/location.dart';
import 'package:location/services/habitation_service.dart';
import 'package:location/services/location_service.dart';
import 'package:location/views/share/bottom_navigation_bar_widget.dart';
import 'package:location/views/share/custom_app_bar.dart';

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
      appBar: CustomAppBar(titleContent: 'Mes locations'),
      body: Center(
        child: FutureBuilder(
          future: _locations,
          builder: (context, snapshot) {
            print(snapshot.data?.map((message) => message.idhabitation));
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
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(HabitationService()
                        .getHabitationDetailsById(location.idhabitation)
                        .libelle),
                    subtitle: Text(HabitationService()
                        .getHabitationDetailsById(location.idhabitation)
                        .adresse),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Text('${location.montanttotal.toInt()} €',
                      style: const TextStyle(fontSize: 20)),
                ),
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
                      style: const TextStyle(color: darkBlue, fontSize: 18),
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
                        style: const TextStyle(color: darkBlue, fontSize: 18),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              location.facture != null
                  ? 'Facture délivrée le ${_formatDate(location.facture!.date)}'
                  : 'Aucune facture',
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
