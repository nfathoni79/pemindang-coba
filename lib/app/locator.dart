import 'package:get_it/get_it.dart';
import 'package:pemindang_coba/services/auction_service.dart';
import 'package:pemindang_coba/services/lio_service.dart';
import 'package:pemindang_coba/services/prefs_service.dart';
import 'package:pemindang_coba/services/store_service.dart';
import 'package:pemindang_coba/services/user_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefsService = await PrefsService.getInstance();
  locator.registerSingleton<PrefsService>(prefsService);

  locator.registerLazySingleton(() => LioService());
  locator.registerLazySingleton(() => AuctionService());
  locator.registerLazySingleton(() => StoreService());
  locator.registerLazySingleton(() => UserService());
}