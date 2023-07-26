import 'package:flutter/material.dart';
import 'package:pemindang_coba/viewmodels/main_view_model.dart';
import 'package:stacked/stacked.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({super.key});

  @override
  Widget builder(BuildContext context, MainViewModel viewModel, Widget? child) {
    return Scaffold(
      body: viewModel.getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Colors.blue.shade50,
        unselectedItemColor: Colors.blue.shade300,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Lelang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Anda',
          ),
        ],
        currentIndex: viewModel.navbarIndex,
        onTap: viewModel.onNavbarItemTapped,
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(BuildContext context) => MainViewModel();
}
