import 'package:dio/dio.dart';
import 'package:flutter_clean_boilerplate/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_clean_boilerplate/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_clean_boilerplate/data/model/api_response.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/repositories/travela_search_repository_interface.dart';
import 'package:flutter_clean_boilerplate/utill/app_constants.dart';

class TravelaSearchRepository implements TravelaSearchRepositoryInterface {
  final DioClient dioClient;

  TravelaSearchRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> getPopularLocations(String query) async {
    try {
      final response = await dioClient.get(
        AppConstants.popularLocationsUri,
        queryParameters: {'q': query},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> searchAccommodationsStream(
    Map<String, dynamic> queryParameters, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dioClient.dio!.get<ResponseBody>(
        AppConstants.searchStreamUri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
