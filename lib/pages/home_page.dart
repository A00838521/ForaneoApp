import 'package:flutter/material.dart';
// import 'package:foraneoapp/widgets/noticia.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Colors.green[900],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Noticias',
                style: TextStyle(
                    color: Color.fromRGBO(120, 170, 85, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(
              color: Colors.white,
              height: 0,
              thickness: 1,
              indent: 25,
              endIndent: 25,
            ),
            // Noticia(),
          ],
        ),
      ),
    );
  }
}
