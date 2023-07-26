import 'package:flutter/material.dart';
import 'package:pemindang_coba/views/home_view.dart';
import 'package:pemindang_coba/views/auctions_view.dart';
import 'package:pemindang_coba/views/yours_view.dart';
import 'package:stacked/stacked.dart';

class MainViewModel extends ReactiveViewModel {
  int _navbarIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const AuctionsView(),
    const YoursView(),
  ];

  int get navbarIndex => _navbarIndex;

  void onNavbarItemTapped(int index) {
    _navbarIndex = index;
    notifyListeners();
  }

  Widget getCurrentScreen() => _screens[_navbarIndex];
}