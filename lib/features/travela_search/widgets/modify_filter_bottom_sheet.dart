import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/date_range_picker_widget.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/guest_counter_widget.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';

class ModifyFilterBottomSheet extends StatefulWidget {
  final double initialMinPrice;
  final double initialMaxPrice;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final int initialAdults;
  final int initialChildren;
  final int initialInfants;
  final Function(
    double minPrice,
    double maxPrice,
    DateTime startDate,
    DateTime endDate,
    int adults,
    int children,
    int infants,
  ) onApplyFilters;

  const ModifyFilterBottomSheet({
    super.key,
    this.initialMinPrice = 1000,
    this.initialMaxPrice = 10000,
    this.initialStartDate,
    this.initialEndDate,
    this.initialAdults = 1,
    this.initialChildren = 0,
    this.initialInfants = 0,
    required this.onApplyFilters,
  });

  static Future<void> show(
    BuildContext context, {
    required double initialMinPrice,
    required double initialMaxPrice,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    required int initialAdults,
    required int initialChildren,
    required int initialInfants,
    required Function(
      double minPrice,
      double maxPrice,
      DateTime startDate,
      DateTime endDate,
      int adults,
      int children,
      int infants,
    ) onApplyFilters,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ModifyFilterBottomSheet(
        initialMinPrice: initialMinPrice,
        initialMaxPrice: initialMaxPrice,
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        initialAdults: initialAdults,
        initialChildren: initialChildren,
        initialInfants: initialInfants,
        onApplyFilters: onApplyFilters,
      ),
    );
  }

  @override
  State<ModifyFilterBottomSheet> createState() =>
      _ModifyFilterBottomSheetState();
}

class _ModifyFilterBottomSheetState extends State<ModifyFilterBottomSheet> {
  late RangeValues _currentRangeValues;
  late DateTime _startDate;
  late DateTime _endDate;
  late int _adults;
  late int _children;
  late int _infants;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(
      widget.initialMinPrice,
      widget.initialMaxPrice,
    );
    _startDate = widget.initialStartDate ?? DateTime.now().add(const Duration(days: 1));
    _endDate = widget.initialEndDate ?? DateTime.now().add(const Duration(days: 3));
    _adults = widget.initialAdults;
    _children = widget.initialChildren;
    _infants = widget.initialInfants;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            alignment: Alignment.center,
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.hintColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 4, 16, 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.4),
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter Stays",
                  style: textBold.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 22,
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeDefault,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateRangePickerWidget(
                    initialStartDate: _startDate,
                    initialEndDate: _endDate,
                    onDateRangeSelected: (start, end) {
                      setState(() {
                        _startDate = start;
                        _endDate = end;
                      });
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  GuestCounterWidget(
                    initialAdults: _adults,
                    initialChildren: _children,
                    initialInfants: _infants,
                    onGuestsChanged: (adults, children, infants) {
                      setState(() {
                        _adults = adults;
                        _children = children;
                        _infants = infants;
                      });
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.sell_outlined,
                              color: theme.primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: Dimensions.paddingSizeEight),
                            Text(
                              "Price Range (per night)",
                              style: textBold.copyWith(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeTwelve),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PriceBadge(
                              label: "Minimum",
                              amount: "BDT ${_currentRangeValues.start.round()}",
                            ),
                            Text(
                              "-",
                              style: textBold.copyWith(
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            PriceBadge(
                              label: "Maximum",
                              amount: "BDT ${_currentRangeValues.end.round()}",
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: theme.primaryColor,
                            inactiveTrackColor: theme.colorScheme.secondaryContainer,
                            trackHeight: 4.0,
                            thumbColor: theme.primaryColor,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                            overlayColor: theme.primaryColor.withOpacity(0.1),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                          ),
                          child: RangeSlider(
                            values: _currentRangeValues,
                            min: 500,
                            max: 20000,
                            divisions: 39,
                            labels: RangeLabels(
                              "BDT ${_currentRangeValues.start.round()}",
                              "BDT ${_currentRangeValues.end.round()}",
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _currentRangeValues = values;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(
              left: Dimensions.paddingSizeDefault,
              right: Dimensions.paddingSizeDefault,
              top: Dimensions.paddingSizeDefault,
              bottom: MediaQuery.of(context).padding.bottom + Dimensions.paddingSizeDefault,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentRangeValues = const RangeValues(1000, 10000);
                        _startDate = DateTime.now().add(const Duration(days: 1));
                        _endDate = DateTime.now().add(const Duration(days: 3));
                        _adults = 1;
                        _children = 0;
                        _infants = 0;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      ),
                      side: BorderSide(color: theme.colorScheme.outline),
                    ),
                    child: Text(
                      "Reset All",
                      style: textBold.copyWith(color: theme.hintColor),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeTwelve),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApplyFilters(
                        _currentRangeValues.start,
                        _currentRangeValues.end,
                        _startDate,
                        _endDate,
                        _adults,
                        _children,
                        _infants,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Apply Filters",
                      style: textBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PriceBadge extends StatelessWidget {
  final String label;
  final String amount;

  const PriceBadge({
    super.key,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeEight,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textRegular.copyWith(
                color: theme.hintColor,
                fontSize: Dimensions.fontSizeExtraSmall,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              amount,
              style: textBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
