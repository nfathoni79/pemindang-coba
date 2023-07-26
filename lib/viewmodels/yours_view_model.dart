import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/auction.dart';
import 'package:pemindang_coba/models/store.dart';
import 'package:pemindang_coba/services/auction_service.dart';
import 'package:pemindang_coba/services/store_service.dart';
import 'package:stacked/stacked.dart';

class YoursViewModel extends MultipleFutureViewModel {
  static const String auctionsKey = 'auctions';

  final _storeService = locator<StoreService>();
  final _auctionService = locator<AuctionService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    auctionsKey: getYourAuctionsByStore,
  };

  bool get auctionsBusy => busy(auctionsKey);

  Store? get currentStore => _storeService.currentStore;
  List<Auction> get auctions => dataMap?[auctionsKey];

  Future<List<Store>> getStores() {
    return _storeService.getStores();
  }

  Future<List<Auction>> getYourAuctionsByStore() async {
    Store? store = _storeService.currentStore;

    if (store == null) {
      List<Store> stores = await _storeService.getStores();
      _storeService.setCurrentStore(stores[0]);
      store = _storeService.currentStore;
    }

    return _auctionService.getYourAuctionsByStore(store!.slug);
  }

  void setCurrentStore(Store store) {
    return _storeService.setCurrentStore(store);
  }
}