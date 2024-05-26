import 'package:flutter/material.dart';
import 'package:foraneoapp/pages/home_page.dart';
import 'package:foraneoapp/pages/about_page.dart';
import 'package:foraneoapp/pages/details_page.dart';
import 'package:foraneoapp/pages/login.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AboutPage(),
    DetailsPage(),
    LoginPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(
              vertical: 10), // Ajusta el margen según tus necesidades
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 47, 105, 49), // Cambia el color de fondo
            borderRadius:
                BorderRadius.circular(25), // Redondea los bordes del contenedor
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(25), // Redondea los bordes del contenedor
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Account',
                ),
              ],
              backgroundColor:
                  Color.fromARGB(255, 47, 105, 49), // Cambia el color de fondo
              selectedItemColor:
                  Colors.white, // Cambia el color del ítem seleccionado
              unselectedItemColor:
                  Colors.grey, // Cambia el color del ítem no seleccionado
              showSelectedLabels:
                  true, // Muestra etiquetas para los ítems seleccionados
              showUnselectedLabels:
                  true, // Muestra etiquetas para los ítems no seleccionados
            ),
          ),
        ),
      ),
    );
  }
}
