import 'package:get_it/get_it.dart';
import 'package:quickk/services/LocationService.dart';
import 'package:quickk/services/UserDataServcie.dart';

final getIt = GetIt.instance;


setupServiceLocator() {
  // Register UserDataService
  getIt.registerLazySingleton<UserDataService>(() => UserDataService());
  // Register LocationDataService
  getIt.registerLazySingleton<LocationDataService>(() => LocationDataService());
}