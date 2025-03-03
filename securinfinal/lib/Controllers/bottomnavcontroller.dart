
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securinfinal/screens/chatbot/mainchat.dart';
import 'package:securinfinal/screens/crimescore/crimescore.dart';
import 'package:securinfinal/screens/profile/profilepage.dart';
import 'package:securinfinal/screens/userhome/userhome.dart';
import 'package:securinfinal/screens/wallet/walletscreen.dart';

class NavController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = [
    HomePage(),
    GeminiChatScreen(),
    CrimeScoreMeterPage(),
    WalletScreen(),
    ProfilePage(),


  ];
  void changeIndex(int index) {
    currentIndex.value = index;
  }}