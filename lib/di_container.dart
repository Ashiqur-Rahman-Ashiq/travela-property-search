import 'package:flutter_clean_boilerplate/data/local/app_database.dart';
import 'package:flutter_clean_boilerplate/theme/controllers/theme_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_clean_boilerplate/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_clean_boilerplate/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:flutter_clean_boilerplate/utill/app_constants.dart';

import 'package:flutter_clean_boilerplate/features/travela_search/controllers/travela_search_controller.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/repositories/travela_search_repository.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/repositories/travela_search_repository_interface.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/services/travela_search_service.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/services/travela_search_service_interface.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppDatabase());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl()));

  sl.registerLazySingleton(() => ThemeController(sharedPreferences: sl()));

  sl.registerLazySingleton<TravelaSearchRepositoryInterface>(
    () => TravelaSearchRepository(dioClient: sl()),
  );
  sl.registerLazySingleton<TravelaSearchServiceInterface>(
    () => TravelaSearchService(travelaSearchRepositoryInterface: sl()),
  );
  sl.registerFactory(
    () => TravelaSearchController(travelaSearchServiceInterface: sl()),
  );
}
