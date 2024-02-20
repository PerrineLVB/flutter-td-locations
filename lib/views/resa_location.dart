import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/models/habitation.dart';

class ResaLocation extends StatefulWidget {
  const ResaLocation({super.key});

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
  Widget build(BuildContext context) {
    // _loadOptionPayantes();
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation'),
      ),
      body: ListView(
        padding: EdgeInsets.all(4.0),
        children: [
          // _buildResume(),
          // _buildDates(),
          // _buildNbPersonnes(),
          // _buildOptionsPayantes(context),
          // TotalWidget(prixTotal),
          // _buildRentButton(),
        ],
      ),
    );
  }
}
