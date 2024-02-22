import 'package:flutter/material.dart';

class ProfilArgument {
  final String routeNameNext;

  ProfilArgument(this.routeNameNext);
}

class Profil extends StatelessWidget {
  static String routeName = 'profil';
  final String routeNameNext;

  const Profil(this.routeNameNext, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text("Widget à faire");
  }
}