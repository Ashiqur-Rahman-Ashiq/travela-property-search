import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/date_range_picker_widget.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/widgets/guest_counter_widget.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';

class GuestAndDateSelectionScreen extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final int initialGuests;

  const GuestAndDateSelectionScreen({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.initialGuests = 1,
  });

  @override
  State<GuestAndDateSelectionScreen> createState() =>
      _GuestAndDateSelectionScreenState();
}

class _GuestAndDateSelectionScreenState
    extends State<GuestAndDateSelectionScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  late int _adults;
  int _children = 0;
  int _infants = 0;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate ??
        DateTime.now().add(const Duration(days: 1));
    _endDate =
        widget.initialEndDate ?? DateTime.now().add(const Duration(days: 3));
    _adults = widget.initialGuests > 0 ? widget.initialGuests : 1;
  }

  void _onSearchSubmitted() {
    final totalGuests = _adults + _children;

    Navigator.pop(context, {
      'startDate': _startDate,
      'endDate': _endDate,
      'guests': totalGuests,
      'adults': _adults,
      'children': _children,
      'infants': _infants,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: theme.textTheme.bodyLarge?.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Select Dates & Guests",
          style: textBold.copyWith(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: Dimensions.fontSizeExtraLarge,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
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
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSearchSubmitted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Search Properties",
                    style: textBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
