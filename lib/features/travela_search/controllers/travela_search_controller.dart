import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/data/model/api_response.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/models/search_ui_state.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/models/travela_accommodation_model.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/models/travela_location_model.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/services/travela_search_service_interface.dart';

class TravelaSearchController extends ChangeNotifier {
  final TravelaSearchServiceInterface travelaSearchServiceInterface;

  TravelaSearchController({required this.travelaSearchServiceInterface});

  SearchUIState _uiState = SearchUIState.initial;
  List<TravelaLocationModel> _locationSuggestions = [];
  List<TravelaAccommodationModel> _stayResults = [];
  bool _isLoadingSuggestions = false;
  bool _isLoading = false;
  int _totalMetaCount = 0;
  String? _errorMessage;

  int? _offset = 1;
  int? _totalSize;

  String? _currentSseEvent;
  CancelToken? _cancelToken;
  StreamSubscription? _streamSubscription;

  SearchUIState get uiState => _uiState;
  List<TravelaLocationModel> get locationSuggestions => _locationSuggestions;
  List<TravelaAccommodationModel> get stayResults => _stayResults;
  bool get isLoadingSuggestions => _isLoadingSuggestions;
  bool get isLoading => _isLoading;
  int get totalMetaCount => _totalMetaCount;
  String? get errorMessage => _errorMessage;
  int? get offset => _offset;
  int? get totalSize => _totalSize;

  Future<void> fetchLocationSuggestions(String query) async {
    if (query.trim().isEmpty) {
      _locationSuggestions = [];
      _isLoadingSuggestions = false;
      notifyListeners();
      return;
    }

    _isLoadingSuggestions = true;
    notifyListeners();

    ApiResponseModel apiResponse = await travelaSearchServiceInterface.getPopularLocations(query);

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final dynamic responseData = apiResponse.response!.data;
      final List<dynamic> data = (responseData is Map && responseData.containsKey('data'))
          ? responseData['data']
          : (responseData is List ? responseData : []);

      _locationSuggestions = data.map((json) => TravelaLocationModel.fromJson(json)).toList();
    } else {
      _locationSuggestions = [];
    }
    _isLoadingSuggestions = false;
    notifyListeners();
  }

  void cancelSearchStream() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('User cancelled search stream');
      _cancelToken = null;
    }
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  Future<void> startSearchStream({
    required Map<String, dynamic> queryParameters,
    int offset = 1,
  }) async {
    cancelSearchStream();

    _offset = offset;
    if (offset == 1) {
      _stayResults = [];
      _uiState = SearchUIState.streaming;
    }
    _isLoading = true;
    _errorMessage = null;
    _currentSseEvent = null;
    notifyListeners();

    _cancelToken = CancelToken();

    ApiResponseModel apiResponse = await travelaSearchServiceInterface.searchAccommodationsStream(
      queryParameters,
      cancelToken: _cancelToken,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      final ResponseBody responseBody = apiResponse.response!.data as ResponseBody;

      _streamSubscription = responseBody.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (String line) {
          _parseSSELine(line);
        },
        onError: (error) {
          if (error is DioException && CancelToken.isCancel(error)) return;
          _isLoading = false;
          _uiState = SearchUIState.error;
          _errorMessage = error.toString();
          notifyListeners();
        },
        onDone: () {
          _isLoading = false;
          _uiState = _stayResults.isEmpty ? SearchUIState.empty : SearchUIState.success;
          notifyListeners();
        },
      );
    } else {
      _isLoading = false;
      _uiState = _stayResults.isEmpty ? SearchUIState.empty : SearchUIState.error;
      _errorMessage = apiResponse.error?.toString() ?? "Failed to connect to search service";
      notifyListeners();
    }
  }

  void _parseSSELine(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return;

    if (trimmed.startsWith('event:')) {
      _currentSseEvent = trimmed.substring(6).trim();
      return;
    }

    if (trimmed.startsWith('data:')) {
      final String jsonStr = trimmed.substring(5).trim();
      if (jsonStr.isEmpty || jsonStr == '{}') {
        if (_currentSseEvent == 'done') {
          _isLoading = false;
          if (_stayResults.isEmpty) {
            _uiState = SearchUIState.empty;
          } else {
            _uiState = SearchUIState.success;
          }
          notifyListeners();
        }
        return;
      }

      try {
        final dynamic parsed = jsonDecode(jsonStr);
        if (parsed is Map<String, dynamic>) {
          if (_currentSseEvent == 'meta' || parsed.containsKey('total_count') || parsed.containsKey('pagination')) {
            _totalMetaCount = parsed['total_count'] as int? ??
                (parsed['pagination'] as Map<String, dynamic>?)?['total_count'] as int? ??
                parsed['total'] as int? ??
                0;
            _totalSize = _totalMetaCount;
          } else if (_currentSseEvent == 'item' || (parsed.containsKey('id') && parsed.containsKey('title'))) {
            final item = TravelaAccommodationModel.fromJson(parsed);
            _stayResults.add(item);
          } else if (_currentSseEvent == 'error') {
            _uiState = SearchUIState.error;
            _errorMessage = parsed['message'] as String? ?? "Stream error occurred";
          }
        }
        notifyListeners();
      } catch (_) {
      }
    }
  }

  void resetSearch() {
    cancelSearchStream();
    _uiState = SearchUIState.initial;
    _stayResults = [];
    _locationSuggestions = [];
    _isLoadingSuggestions = false;
    _isLoading = false;
    _totalMetaCount = 0;
    _offset = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    cancelSearchStream();
    super.dispose();
  }
}
