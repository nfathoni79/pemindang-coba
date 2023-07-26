import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/auction.dart';
import 'package:pemindang_coba/models/store.dart';
import 'package:pemindang_coba/services/auction_service.dart';
import 'package:pemindang_coba/services/store_service.dart';
import 'package:stacked/stacked.dart';

class AuctionsViewModel extends MultipleFutureViewModel {
  static const String storesKey = 'stores';
  static const String auctionsKey = 'auctions';

  final _storeService = locator<StoreService>();
  final _auctionService = locator<AuctionService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    storesKey: getStores,
    auctionsKey: getAuctionsByStore,
  };

  bool get storesBusy => busy(storesKey);
  bool get auctionsBusy => busy(auctionsKey);

  List<Store> get stores => dataMap?[storesKey];
  List<Auction> get auctions => dataMap?[auctionsKey];
  Store? get currentStore => _storeService.currentStore;

  Future<List<Store>> getStores() {
    return _storeService.getStores();
  }

  Future<List<Auction>> getAuctionsByStore() async {
    Store? store = _storeService.currentStore;

    if (store == null) {
      List<Store> stores = await _storeService.getStores();
      _storeService.setCurrentStore(stores[0]);
      store = _storeService.currentStore;
    }

    return _auctionService.getAuctionsByStore(store!.slug);
  }

  void setCurrentStore(Store store) {
    return _storeService.setCurrentStore(store);
  }
}