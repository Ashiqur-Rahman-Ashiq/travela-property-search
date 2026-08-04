import 'package:dio/dio.dart';
import 'package:flutter_clean_boilerplate/data/model/api_response.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/repositories/travela_search_repository_interface.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/services/travela_search_service_interface.dart';

class TravelaSearchService implements TravelaSearchServiceInterface {
  final TravelaSearchRepositoryInterface travelaSearchRepositoryInterface;

  TravelaSearchService({required this.travelaSearchRepositoryInterface});

  @override
  Future<ApiResponseModel> getPopularLocations(String query) {
    return travelaSearchRepositoryInterface.getPopularLocations(query);
  }

  @override
  Future<ApiResponseModel> searchAccommodationsStream(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  }) {
    return travelaSearchRepositoryInterface.searchAccommodationsStream(
      queryParameters,
      cancelToken: cancelToken,
    );
  }
}
