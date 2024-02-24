import 'package:flutter/material.dart';
import 'package:location/views/location_list.dart';
import 'package:location/views/profil.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int indexSelected;
  const BottomNavigationBarWidget(this.indexSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isUserNotConnected = true;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: indexSelected,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Recherche',
        ),
        BottomNavigationBarItem(
          icon: isUserNotConnected
              ? const Icon(Icons.shopping_cart_outlined)
              : const BadgeWidget(
                  value: 0,
                  top: 0,
                  right: 0,
                  child: Icon(Icons.shopping_cart),
                ),
          label: 'locations',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        String page = '/';
        switch (index) {
          case 2:
            page = LocationList.routeName;
            break;
          case 3:
            page = Profil.routeName;
            break;
        }
        Navigator.pushNamedAndRemoveUntil(
          context,
          page,
          (route) => false,
        );
      },
    );
  }
}

class BadgeWidget extends StatelessWidget {
  final double top;
  final double right;
  final Widget child;
  final int value;
  final Color? color;

  const BadgeWidget({super.key, 
    required this.child,
    required this.value,
    required this.top,
    required this.right,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        value == 0
            ? Container()
            : Positioned(
                right: right,
                top: top,
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: color ?? Colors.red),
                  child: Text(
                    value.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
      ],
    );
  }
}