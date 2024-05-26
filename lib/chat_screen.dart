import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:math';

Color color_main = Color.fromARGB(170, 120, 170, 85);
Color color_sec = Color.fromARGB(255, 29, 60, 35);
Color color_accent = Color.fromARGB(191,127,190,145);

class ChatScreen extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatScreen> {
  // si se quiere conectar a firebase sería hacer una función que lea el dataser y deje los strings de mensajes aqui :p
  //final Firebase.......
  //final Firebase ... autentificacion de cada usuario tmb:)
  final List<Map<String, String>> messages = [
    {
      'userName': 'User1',
      'message':
          'Hola, ¿cómo estás? Hola, ¿cómo estás? Hola, ¿cómo estás? Hola, ¿cómo estás? Hola, ¿cómo estás? Hola, ¿cómo estás? Hola, ¿cómo estás? Hola, ¿cómo estás? Hola, ¿cómo estás? Hola, ¿cómo estás? Hola, ¿cómo estás?',
      'date': '2024-05-26',
      'time': '12:00 PM',
    },
    {
      'userName': 'User2',
      'message': 'Bien, gracias. ¿Y tú?',
      'date': '2024-05-26',
      'time': '12:05 PM',
    },
    // aqui se pueden agregar mas o hacer un csv o ...
  ];

  final TextEditingController _textEditingController = TextEditingController();

  void _sendMessage(String messageText) {
    setState(() {
      messages.insert(0, {
        'userName': 'Me',
        'message': messageText,
        'date': '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        'time': '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}',
      });
      _textEditingController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true, // Para mostrar los mensajes desde la parte inferior
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUserMessage = message['userName'] == 'Me';
                  return ChatBubble(
                    userName: message['userName']!,
                    message: message['message']!,
                    date: message['date']!,
                    time: message['time']!,
                    isUserMessage: isUserMessage,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0 ,right: 18.0, top: 0, bottom: 18.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _sendMessage(_textEditingController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String userName;
  final String message;
  final String date;
  final String time;
  final bool isUserMessage;

  const ChatBubble({
    required this.userName,
    required this.message,
    required this.date,
    required this.time,
    required this.isUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0,right: 20.0, top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUserMessage) ...[
            CircleAvatar(
              child: Text(userName[0]),
              backgroundColor: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1),
            ),
            SizedBox(width: 10.0),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: isUserMessage ? color_accent: color_main,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isUserMessage ? 15.0 : 0),
                      topRight: Radius.circular(isUserMessage ? 0 : 15.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: isUserMessage ? color_sec: Colors.black),
                  ),
                ),
                Text(
                  '$date $time',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isUserMessage) ...[
            SizedBox(width: 10.0),
            CircleAvatar(
              child: Text(userName[0]),
            ),
          ],
        ],
      ),
    );
  }
}
