import 'package:flutter/material.dart';

class ForoScreen extends StatefulWidget {
  @override
  _ForoPageState createState() => _ForoPageState();
}

class _ForoPageState extends State<ForoScreen> {
  List<Map<String, String>> mensajes = [
    {
      'title': 'Encontré un descuento en un gimnasio cerca;)',
      'message':
          '¡Aprovecha nuestra oferta especial de inscripción en el gimnasio este mes! Obtén un 30% de descuento en tu membresía anual. ¡No pierdas la oportunidad de ponerte en forma!',
      'date': '2024-05-26',
      'time': '10:00 AM',
    },
    {
      'title': 'Buen día',
      'message':
          'Suerte en exámenes!',
      'date': '2024-05-25',
      'time': '09:30 PM',
    },
    {
      'title': 'Concierto iluminado con velas',
      'message':
          'En Monterrey! Conciertos únicos interpretados a la luz de las velas. Disfruta de la música de los mejores compositores clásicos en un entorno íntimo e impresionante.',
      'date': '2024-05-24',
      'time': '03:15 PM',
    },
    // mas para pruebas
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: mensajes.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text(
                    mensajes[index]['title'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),
                  ),
                  subtitle: Text(
                    mensajes[index]['message'] ?? '',
                    style: TextStyle(color: const Color.fromARGB(255, 205, 205, 205)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Colors.green,
                  thickness: 2.0,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 47, 105, 49),
        onPressed: () {
          _agregarMensaje(context);
        },
        tooltip: 'Agregar Mensaje',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _agregarMensaje(BuildContext context) async {
    Map<String, String> nuevoMensaje = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController tituloController = TextEditingController();
        TextEditingController mensajeController = TextEditingController();

        return AlertDialog(
          title: Text('Nuevo Mensaje'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: tituloController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: mensajeController,
                decoration: InputDecoration(labelText: 'Mensaje'),
                maxLines: null,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'title': tituloController.text,
                  'message': mensajeController.text,
                  'date': DateTime.now().toString(),
                  'time': TimeOfDay.now().format(context),
                });
              },
              child: Text('Publicar'),
            ),
          ],
        );
      },
    );

    if (nuevoMensaje != null) {
      setState(() {
        mensajes.add(nuevoMensaje);
      });
    }
  }
}
