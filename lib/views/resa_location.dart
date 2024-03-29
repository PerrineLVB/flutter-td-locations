import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/colors.dart';
import 'package:location/models/habitation.dart';
import 'package:location/views/share/custom_app_bar.dart';

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
  List<int> nbPersonnesList = List.generate(8, (index) => index + 1);
  int selectedNbPersonnes = 1;

  var format = NumberFormat('### €');

  @override
  void initState() {
    super.initState();
    _loadOptionPayantes();
  }

  _buildResume() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: lightBlue,
        leading: const Icon(Icons.home),
        title: Text(widget.habitation.libelle),
        subtitle: Text(widget.habitation.adresse),
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
                setState(() {
                  selectedNbPersonnes = value;
                });
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

  _loadOptionPayantes() {
    optionPayanteChecks = widget.habitation.optionspayantes
        .map((option) => OptionPayanteCheck(option.id, option.libelle, false,
            description: option.description, prix: option.prix))
        .toList();
  }

  _buildOptionsPayantes(BuildContext context) {
    return Wrap(
      children: Iterable.generate(
        optionPayanteChecks.length,
        (index) {
          var option = optionPayanteChecks[index];
          return CheckboxListTile(
            title: Text(option.libelle),
            subtitle: Text(option.description),
            value: option.checked,
            onChanged: (bool? value) {
              setState(() {
                option.checked = value ?? false;
              });
            },
            secondary: Text(format.format(option.prix)),
          );
        },
      ).toList(),
    );
  }

  double calculateTotalPrice() {
    int numberOfNights = dateFin.difference(dateDebut).inDays;
    if (numberOfNights == 0) {
      return 0.0;
    }
    double pricePerNight = widget.habitation.prixnuit;
    double totalPrice = numberOfNights * pricePerNight * selectedNbPersonnes;

    for (var option in optionPayanteChecks) {
      if (option.checked) {
        totalPrice += option.prix;
      }
    }

    return totalPrice;
  }

  _buildRentButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                print('Rent button pressed');
              },
              child: const Text(
                'Louer',
                style: TextStyle(
                  color: Colors.white, // white text color
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleContent: 'Réservation'),
      body: ListView(
        padding: const EdgeInsets.all(4.0),
        children: [
          _buildResume(),
          _buildDates(),
          _buildNbPersonnes(),
          _buildOptionsPayantes(context),
          TotalWidget(prixTotal: calculateTotalPrice()),
          _buildRentButton(),
        ],
      ),
    );
  }
}

class TotalWidget extends StatelessWidget {
  final double prixTotal;

  const TotalWidget({super.key, required this.prixTotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: darkBlue, width: 2.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ),
          ),
          Text(
            '${prixTotal.toStringAsFixed(2)} €',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
