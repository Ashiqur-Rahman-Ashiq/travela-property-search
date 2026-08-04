import 'package:dio/dio.dart';
import 'package:flutter_clean_boilerplate/data/model/api_response.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/controllers/travela_search_controller.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/services/travela_search_service_interface.dart';
import 'package:flutter_clean_boilerplate/theme/controllers/theme_controller.dart';
import 'package:flutter_clean_boilerplate/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeTravelaSearchService implements TravelaSearchServiceInterface {
  @override
  Future<ApiResponseModel> getPopularLocations(String query) async {
    return ApiResponseModel.withSuccess(
      Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {'data': []},
      ),
    );
  }

  @override
  Future<ApiResponseModel> searchAccommodationsStream(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  }) async {
    return ApiResponseModel.withSuccess(
      Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: null,
      ),
    );
  }
}

void main() {
  testWidgets('App boots correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TravelaSearchController(travelaSearchServiceInterface: _FakeTravelaSearchService())),
        ChangeNotifierProvider(create: (_) => ThemeController(sharedPreferences: sharedPreferences)),
      ],
      child: const MyApp(),
    ));
    await tester.pump();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
