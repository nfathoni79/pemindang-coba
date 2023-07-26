import 'package:get_it/get_it.dart';
import 'package:pemindang_coba/services/auction_service.dart';
import 'package:pemindang_coba/services/lio_service.dart';
import 'package:pemindang_coba/services/prefs_service.dart';
import 'package:pemindang_coba/services/store_service.dart';
import 'package:pemindang_coba/services/user_service.dart';

final locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => LioService());
  locator.registerLazySingleton(() => PrefsService());
  locator.registerLazySingleton(() => AuctionService());
  locator.registerLazySingleton(() => StoreService());
  locator.registerLazySingleton(() => UserService());
}