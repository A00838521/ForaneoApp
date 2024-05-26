import 'package:flutter/material.dart';
import 'package:foraneoapp/foro_screen.dart';
import 'package:foraneoapp/chat_screen.dart';
//Color color_main = Color.fromARGB(170, 120, 170, 85);
//Color color_sec = Color.fromARGB(255,44,88,52);
//Color color_accent = Color.fromARGB(191,127,190,145);

class ChatTabview extends StatelessWidget {
  // Crear tab view y conectar a las páginas
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor:
                  Colors.transparent, // Para ocultar el indicador por defecto
              tabs: [
                TabBarCustomItem(label: 'Foro', icon: Icons.forum, index: 0),
                TabBarCustomItem(label: 'Chat', icon: Icons.chat, index: 1),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ForoScreen(),
              ChatScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarCustomItem extends StatelessWidget {
  // Cambiar de color en cada tab
  final String label;
  final IconData icon;
  final int index;

  const TabBarCustomItem(
      {required this.label, required this.icon, required this.index});
  @override
  Widget build(BuildContext context) {
    final TabController? tabController = DefaultTabController.of(context);

    return Tab(
      child: AnimatedBuilder(
        animation: tabController!,
        builder: (context, child) {
          final isSelected = tabController.index == index;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color.fromARGB(170, 120, 170, 85)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: isSelected
                        ? Color.fromARGB(255, 44, 88, 52)
                        : Colors.black),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    //color: isSelected ? color_accent : Colors.black,
                    color: isSelected
                        ? Color.fromARGB(255, 44, 88, 52)
                        : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
