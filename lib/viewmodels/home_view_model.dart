import 'package:flutter/material.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/auction.dart';
import 'package:pemindang_coba/models/seaseed_user.dart';
import 'package:pemindang_coba/services/auction_service.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends MultipleFutureViewModel {
  static const String seaseedKey = 'seaseed';
  static const String auctionsKey = 'auctions';

  final _userService = locator<UserService>();
  final _auctionService = locator<AuctionService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    seaseedKey: getSeaseedUser,
    auctionsKey: getRecentAuctions,
  };

  bool get seaseedBusy => busy(seaseedKey);
  bool get auctionsBusy => busy(auctionsKey);

  SeaseedUser get seaseed => dataMap?[seaseedKey];
  List<Auction> get auctions => dataMap?[auctionsKey];

  Future<SeaseedUser?> getSeaseedUser() {
    return _userService.getCurrentSeaseedUser();
  }

  Future<List<Auction>> getRecentAuctions() {
    return _auctionService.getRecentAuctions();
  }
}