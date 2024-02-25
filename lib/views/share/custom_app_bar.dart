import 'package:flutter/material.dart';
import 'package:location/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleContent;

  const CustomAppBar({
    super.key,
    required this.titleContent,
  });

  @override
  Size get preferredSize => const Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleContent,
        style: TextStyle(
          color: darkBlue,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      flexibleSpace: Container(
          decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            mediumBlue,
            white,
          ],
        ),
      )),
    );
  }
}
