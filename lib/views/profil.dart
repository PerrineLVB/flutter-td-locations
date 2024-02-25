import 'package:flutter/material.dart';
import 'package:location/views/share/bottom_navigation_bar_widget.dart';
import 'package:location/views/share/custom_app_bar.dart';

class ProfilArgument {
  final String routeNameNext;

  ProfilArgument(this.routeNameNext);
}

class Profil extends StatelessWidget {
  static String routeName = 'profil';
  final String routeNameNext;

  const Profil(this.routeNameNext, {super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(titleContent: 'Profil'),
      body: Center(
        child: Text('Profil à faire'),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(3),
    );
  }
}
