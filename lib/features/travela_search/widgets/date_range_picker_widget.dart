import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';

class DateRangePickerWidget extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime startDate, DateTime endDate) onDateRangeSelected;

  const DateRangePickerWidget({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onDateRangeSelected,
  });

  @override
  State<DateRangePickerWidget> createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isRange = true;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate ?? DateTime.now().add(const Duration(days: 1));
    _endDate = widget.initialEndDate ?? DateTime.now().add(const Duration(days: 3));
    
    if (_startDate != null && _endDate != null && _startDate!.day == _endDate!.day && _startDate!.month == _endDate!.month && _startDate!.year == _endDate!.year) {
      _isRange = false;
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null && _startDate!.isBefore(_endDate!)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(start: _startDate!, end: _startDate!.add(const Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      widget.onDateRangeSelected(picked.start, picked.end);
    }
  }

  Future<void> _selectSingleDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        _endDate = picked;
      });
      widget.onDateRangeSelected(picked, picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Select Date";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: theme.primaryColor, size: 20),
                  const SizedBox(width: Dimensions.paddingSizeEight),
                  Text(
                    "Select Dates",
                    style: textBold.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
              
              Row(
                children: [
                  ChoiceChip(
                    label: Text("Single", style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: !_isRange ? Colors.white : theme.textTheme.bodyLarge?.color)),
                    selected: !_isRange,
                    selectedColor: theme.primaryColor,
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _isRange = false;
                          _endDate = _startDate;
                        });
                        if (_startDate != null) {
                          widget.onDateRangeSelected(_startDate!, _startDate!);
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: Text("Range", style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: _isRange ? Colors.white : theme.textTheme.bodyLarge?.color)),
                    selected: _isRange,
                    selectedColor: theme.primaryColor,
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _isRange = true;
                          _endDate = _startDate?.add(const Duration(days: 2)) ?? DateTime.now().add(const Duration(days: 3));
                        });
                        if (_startDate != null && _endDate != null) {
                          widget.onDateRangeSelected(_startDate!, _endDate!);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeTwelve),
          InkWell(
            onTap: () => _isRange ? _selectDateRange(context) : _selectSingleDate(context),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeTwelve,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: _isRange
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Check-In",
                              style: textRegular.copyWith(
                                color: theme.hintColor,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(_startDate),
                              style: textBold.copyWith(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_rounded, size: 18, color: theme.hintColor),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Check-Out",
                              style: textRegular.copyWith(
                                color: theme.hintColor,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(_endDate),
                              style: textBold.copyWith(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Booking Date",
                              style: textRegular.copyWith(
                                color: theme.hintColor,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDate(_startDate),
                              style: textBold.copyWith(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.event_available_rounded, color: theme.primaryColor),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
