import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/models/habitation.dart';
import 'package:location/models/type_habitat.dart';
import 'package:location/services/habitation_service.dart';
import 'package:location/share/location_style.dart';
import 'package:location/share/location_text_style.dart';
import 'package:location/views/habitation_details.dart';
import 'package:location/views/habitation_list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/views/location_list.dart';
import 'package:location/views/login_page.dart';
import 'package:location/views/profil.dart';
import 'package:location/views/share/bottom_navigation_bar_widget.dart';
import 'package:location/views/share/custom_app_bar.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Locations',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Mes locations'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('fr')
        ],
        routes: {
          Profil.routeName: (context) => const Profil('/profil'),
          LoginPage.routeName: (context) => const LoginPage('/'),
          LocationList.routeName: (context) =>
              const LocationList('/location_list'),
          // ValidationLocation.routeName: (context) =>
          //     const ValidationLocation('/validation_location'),
        });
  }
}

class MyHomePage extends StatelessWidget {
  final HabitationService service = HabitationService();
  final String title;
  late List<TypeHabitat> _typehabitats;
  late List<Habitation> _habitations;
  MyHomePage({required this.title, super.key}) {
    _habitations = service.getHabitationsTop10();
    _typehabitats = service.getTypeHabitats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(0),
      appBar: CustomAppBar(titleContent: title),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildTypeHabitat(context),
            const SizedBox(height: 20),
            _buildDerniereLocation(context),
          ],
        ),
      ),
    );
  }

  _buildTypeHabitat(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          _typehabitats.length,
          (index) => _buildHabitat(context, _typehabitats[index]),
        ),
      ),
    );
  }

  _buildHabitat(BuildContext context, TypeHabitat typeHabitat) {
    var icon = Icons.house;
    switch (typeHabitat.id) {
      // case 1: House
      case 2:
        icon = Icons.apartment;
        break;
      default:
        icon = Icons.home;
    }
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: LocationStyle.backgroundColorPurple,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitationList(typeHabitat.id == 1),
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white70,
              ),
              const SizedBox(width: 5),
              Text(
                typeHabitat.libelle,
                style: LocationTextStyle.regularWhiteTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildDerniereLocation(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        itemCount: _habitations.length,
        itemExtent: 220,
        itemBuilder: (context, index) =>
            _buildRow(_habitations[index], context),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  _buildRow(Habitation habitation, BuildContext context) {
    var format = NumberFormat("### €");

    return Container(
      width: 240,
      margin: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => HabitationDetails(habitation)),
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/images/locations/${habitation.image}',
                fit: BoxFit.fitWidth,
              ),
            ),
            Text(
              habitation.libelle,
              style: LocationTextStyle.regularTextStyle,
            ),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                Text(
                  habitation.adresse,
                  style: LocationTextStyle.regularTextStyle,
                ),
              ],
            ),
            Text(
              format.format(habitation.prixmois),
              style: LocationTextStyle.boldTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
