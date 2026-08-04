import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clean_boilerplate/common/basewidget/paginated_list_view.dart';
import 'package:flutter_clean_boilerplate/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/controllers/travela_search_controller.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/models/search_ui_state.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/models/travela_location_model.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/screens/guest_and_date_selection_screen.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/location_search_bar.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/modify_filter_bottom_sheet.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/search_stream_status_bar.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/states/empty_result_widget.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/states/error_widget.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/states/initial_search_widget.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/states/no_internet_widget.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/stay_card.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';

class TravelaSearchScreen extends StatefulWidget {
  const TravelaSearchScreen({super.key});

  @override
  State<TravelaSearchScreen> createState() => _TravelaSearchScreenState();
}

class _TravelaSearchScreenState extends State<TravelaSearchScreen> {
  final ScrollController _scrollController = ScrollController();

  TravelaLocationModel? _selectedLocation;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guestCount = 1;
  int _adultsCount = 1;
  int _childrenCount = 0;
  int _infantsCount = 0;
  double _minPrice = 1000;
  double _maxPrice = 10000;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetSearchFilters() {
    _checkInDate = null;
    _checkOutDate = null;
    _guestCount = 1;
    _adultsCount = 1;
    _childrenCount = 0;
    _infantsCount = 0;
    _minPrice = 1000;
    _maxPrice = 10000;
  }

  void _onQueryChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _selectedLocation = null;
        _resetSearchFilters();
      });
      Provider.of<TravelaSearchController>(context, listen: false).resetSearch();
      return;
    }
    Provider.of<TravelaSearchController>(context, listen: false).fetchLocationSuggestions(query);
  }

  void _onLocationSelected(TravelaLocationModel location) async {
    setState(() {
      _selectedLocation = location;
      _resetSearchFilters();
    });

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => GuestAndDateSelectionScreen(
          initialStartDate: _checkInDate,
          initialEndDate: _checkOutDate,
          initialGuests: _guestCount,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _checkInDate = result['startDate'];
        _checkOutDate = result['endDate'];
        _guestCount = result['guests'] ?? 1;
        _adultsCount = result['adults'] ?? 1;
        _childrenCount = result['children'] ?? 0;
        _infantsCount = result['infants'] ?? 0;
      });

      _startSearchStream();
    }
  }

  void _startSearchStream({int offset = 1}) {
    if (_selectedLocation == null) return;

    final String? fromStr = _checkInDate != null
        ? "${_checkInDate!.year}-${_checkInDate!.month.toString().padLeft(2, '0')}-${_checkInDate!.day.toString().padLeft(2, '0')}"
        : null;
    final String? toStr = _checkOutDate != null
        ? "${_checkOutDate!.year}-${_checkOutDate!.month.toString().padLeft(2, '0')}-${_checkOutDate!.day.toString().padLeft(2, '0')}"
        : null;

    final Map<String, dynamic> queryParams = {
      'location_id': _selectedLocation!.id,
      'location': '${_selectedLocation!.lng},${_selectedLocation!.lat}',
      'address_name': _selectedLocation!.name,
      if (_selectedLocation!.within != null) 'within': _selectedLocation!.within,
      if (_selectedLocation!.tier1 != null) 'tier_1': _selectedLocation!.tier1,
      if (_selectedLocation!.tier2 != null) 'tier_2': _selectedLocation!.tier2,
      if (fromStr != null) 'from': fromStr,
      if (toStr != null) 'to': toStr,
      'guest': _guestCount,
      'child': _childrenCount,
      'infant': _infantsCount,
      'rooms': 1,
      'price': '${_minPrice.toInt()}-${_maxPrice.toInt()}',
      'page': offset,
      'per_page': 20,
    };

    Provider.of<TravelaSearchController>(context, listen: false).startSearchStream(
      queryParameters: queryParams,
      offset: offset,
    );
  }

  void _openFilterBottomSheet() {
    ModifyFilterBottomSheet.show(
      context,
      initialMinPrice: _minPrice,
      initialMaxPrice: _maxPrice,
      initialStartDate: _checkInDate,
      initialEndDate: _checkOutDate,
      initialAdults: _adultsCount,
      initialChildren: _childrenCount,
      initialInfants: _infantsCount,
      onApplyFilters: (min, max, start, end, adults, children, infants) {
        setState(() {
          _minPrice = min;
          _maxPrice = max;
          _checkInDate = start;
          _checkOutDate = end;
          _adultsCount = adults;
          _childrenCount = children;
          _infantsCount = infants;
          _guestCount = adults + children;
        });
        _startSearchStream();
      },
    );
  }

  int get _appliedFilterCount {
    int count = 0;
    if (_minPrice != 1000 || _maxPrice != 10000) {
      count++;
    }
    if (_checkInDate != null || _checkOutDate != null) {
      count++;
    }
    if (_adultsCount != 1 || _childrenCount > 0 || _infantsCount > 0) {
      count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope<Object?>(
      onPopInvokedWithResult: (didPop, result) {
        Provider.of<TravelaSearchController>(context, listen: false).cancelSearchStream();
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            title: Text(
              "Travela",
              style: textBold.copyWith(
                color: theme.primaryColor,
                fontSize: Dimensions.fontSizeOverLarge,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_none_rounded, color: theme.textTheme.bodyLarge?.color),
                onPressed: () {
                  showCustomSnackBarWidget(
                    "Notifications will be coming soon!",
                    context,
                    snackBarType: SnackBarType.warning,
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Consumer<TravelaSearchController>(
              builder: (context, searchController, child) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.homePagePadding,
                        vertical: Dimensions.paddingSizeEight,
                      ),
                      child: LocationSearchBar(
                        onQueryChanged: _onQueryChanged,
                        onLocationSelected: _onLocationSelected,
                        onFilterTap: _openFilterBottomSheet,
                        suggestions: searchController.locationSuggestions,
                        isLoadingSuggestions: searchController.isLoadingSuggestions,
                        appliedFilterCount: _appliedFilterCount,
                      ),
                    ),

                    SearchStreamStatusBar(
                      isStreaming: searchController.uiState == SearchUIState.streaming,
                      isDone: searchController.uiState == SearchUIState.success,
                      totalCount: searchController.totalMetaCount,
                      loadedCount: searchController.stayResults.length,
                    ),

                    Expanded(
                      child: _buildBody(context, searchController, theme),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TravelaSearchController controller, ThemeData theme) {
    switch (controller.uiState) {
      case SearchUIState.initial:
        return const InitialSearchWidget();

      case SearchUIState.noInternet:
        return NoInternetWidget(onRetry: () => _startSearchStream());

      case SearchUIState.error:
        return CustomErrorWidget(
          errorMessage: controller.errorMessage,
          onRetry: () => _startSearchStream(),
        );

      case SearchUIState.empty:
        return EmptyResultWidget(onResetFilters: _openFilterBottomSheet);

      case SearchUIState.streaming:
      case SearchUIState.success:
        if (controller.stayResults.isEmpty && controller.uiState == SearchUIState.success) {
          return EmptyResultWidget(onResetFilters: _openFilterBottomSheet);
        }

        return PaginatedListView(
          scrollController: _scrollController,
          totalSize: controller.totalMetaCount,
          offset: controller.offset,
          limit: 20,
          onPaginate: (offset) async {
            if (offset != null) {
              _startSearchStream(offset: offset);
            }
          },
          itemView: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.homePagePadding,
              vertical: Dimensions.paddingSizeEight,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemCount: controller.stayResults.length,
            itemBuilder: (context, index) {
              final stay = controller.stayResults[index];
              return StayCard(
                item: stay,
                onTap: () {
                },
              );
            },
          ),
        );
    }
  }
}
