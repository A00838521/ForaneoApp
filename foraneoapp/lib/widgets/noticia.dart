import 'package:flutter/material.dart';

class Noticia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16), // Ajusta el margen según tus necesidades
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 47, 105, 49), // Cambia el color de fondo
        borderRadius: BorderRadius.circular(25), // Redondea los bordes del contenedor
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25), // Redondea los bordes del contenedor
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Título de la noticia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Descripción de la noticia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                    Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                      Column(
                        children: <Widget>[
                        ClipOval(
                          child: Image.network(
                          'https://via.placeholder.com/50',
                          width: 70,
                          height: 70,
                          fit: BoxFit.fitWidth,
                          ),
                        ),
                        ],
                      ),
                      ],
                    ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}