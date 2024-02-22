import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/colors.dart';
import 'package:location/models/habitation.dart';
import 'package:location/views/habitation_details.dart';

class ResaLocation extends StatefulWidget {
  final Habitation habitation;
  const ResaLocation(this.habitation, {super.key});

  @override
  State<ResaLocation> createState() => _ResaLocationState();
}

class OptionPayanteCheck extends OptionPayante {
  bool checked;

  OptionPayanteCheck(super.id, super.libelle, this.checked,
      {super.description = "", super.prix});
}

class _ResaLocationState extends State<ResaLocation> {
  DateTime dateDebut = DateTime.now();
  DateTime dateFin = DateTime.now();
  String nbPersonnes = '1';
  List<OptionPayanteCheck> optionPayanteChecks = [];

  var format = NumberFormat('### €');

  @override
  void initState() {
    super.initState();
  }

  _buildResume() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: lightBlue,
        leading: const Icon(Icons.home),
        title: Text(widget.habitation.libelle!),
        subtitle: Text(widget.habitation.adresse!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  _buildDates() {
    return Center(
      child: GestureDetector(
        onTap: () => dateTimeRangePicker(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: darkBlue,
                ),
                const SizedBox(width: 8.0),
                Text(
                  _formatDate(dateDebut),
                  style: const TextStyle(color: darkBlue),
                ),
              ],
            ),
            const CircleAvatar(
              radius: 25,
              backgroundColor: darkBlue,
              child: Icon(
                Icons.arrow_right_alt,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: darkBlue,
                ),
                const SizedBox(width: 8.0),
                Text(
                  _formatDate(dateFin),
                  style: const TextStyle(color: darkBlue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'fr_FR').format(date);
  }

  dateTimeRangePicker() async {
    DateTimeRange? datePicked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 2),
      initialDateRange: DateTimeRange(start: dateDebut, end: dateFin),
      cancelText: 'Annuler',
      confirmText: 'Valider',
      locale: const Locale('fr', 'FR'),
    );
    if (datePicked != null) {
      setState(() {
        dateDebut = datePicked.start;
        dateFin = datePicked.end;
      });
    }
  }

  _buildNbPersonnes() {
    List<int> nbPersonnesList = List.generate(8, (index) => index + 1);

    int selectedNbPersonnes = 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text('Nombre de personnes'),
          const SizedBox(width: 10),
          DropdownButton<int>(
            value: selectedNbPersonnes,
            onChanged: (value) {
              print('Selected Number of Persons: $value');
              if (value != null) {
                selectedNbPersonnes = value;
              }
            },
            items: nbPersonnesList.map((int nbPersonnes) {
              return DropdownMenuItem<int>(
                value: nbPersonnes,
                child: Text('$nbPersonnes'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // _loadOptionPayantes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(4.0),
        children: [
          _buildResume(),
          _buildDates(),
          _buildNbPersonnes(),
          // _buildOptionsPayantes(context),
          // TotalWidget(prixTotal),
          // _buildRentButton(),
        ],
      ),
    );
  }
}
