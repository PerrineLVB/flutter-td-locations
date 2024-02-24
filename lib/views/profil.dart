import 'package:flutter/material.dart';

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
    return const Text("Widget à faire");
  }
}