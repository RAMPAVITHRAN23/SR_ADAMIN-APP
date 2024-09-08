import 'package:flutter/material.dart';
import 'package:medx_admin/Screens/yourProducts.dart';
import 'package:medx_admin/Screens/profile.dart';

import 'othersproducts.dart';
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List pages=[YourProducts(),OthersProducts(),Profile()];
  var current=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current,
        onTap: (index){
          setState(() {
            current=index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.production_quantity_limits),label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.short_text_outlined),label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: ""),


        ],
      ),
    );
  }
}


