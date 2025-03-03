import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/bottomnavcontroller.dart';

class BottomNavBarScreen extends StatelessWidget {
  final NavController controller = Get.put(NavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removed
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          backgroundColor: Colors.black, // Changed to black background
          selectedItemColor: Colors.white, // White color for selected items
          unselectedItemColor: Colors.white70, // Slightly transparent white for unselected items
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.black, // Changed to black
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_outlined),
              label: 'chatbot',
              backgroundColor: Colors.black, // Changed to black
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speed),
              label: 'Crimescore',
              backgroundColor: Colors.black, // Changed to black
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Wallet',
              backgroundColor: Colors.black, // Changed to black
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
              backgroundColor: Colors.black, // Changed to black
            ),
          ],
        ),
      ),
    );
  }
}