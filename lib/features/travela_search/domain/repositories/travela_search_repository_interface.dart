import 'package:dio/dio.dart';
import 'package:flutter_clean_boilerplate/data/model/api_response.dart';

abstract class TravelaSearchRepositoryInterface {
  Future<ApiResponseModel> getPopularLocations(String query);
  Future<ApiResponseModel> searchAccommodationsStream(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  });
}
