import 'package:flutter/material.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/store.dart';
import 'package:pemindang_coba/services/lio_service.dart';

class StoreService {
  final _lio = locator<LioService>();

  List<Store> _stores = [];
  Store? _currentStore;

  List<Store> get stores => _stores;
  Store? get currentStore => _currentStore;

  Future<List<Store>> getStores() async {
    _stores = await _lio.getStores();
    return _stores;
  }

  void setCurrentStore(Store store) {
    _currentStore = store;
  }
}