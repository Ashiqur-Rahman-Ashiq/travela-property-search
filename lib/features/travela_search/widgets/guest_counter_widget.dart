import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';

class GuestCounterWidget extends StatefulWidget {
  final int initialAdults;
  final int initialChildren;
  final int initialInfants;
  final Function(int adults, int children, int infants) onGuestsChanged;

  const GuestCounterWidget({
    super.key,
    this.initialAdults = 2,
    this.initialChildren = 0,
    this.initialInfants = 0,
    required this.onGuestsChanged,
  });

  @override
  State<GuestCounterWidget> createState() => _GuestCounterWidgetState();
}

class _GuestCounterWidgetState extends State<GuestCounterWidget> {
  late int _adults;
  late int _children;
  late int _infants;

  @override
  void initState() {
    super.initState();
    _adults = widget.initialAdults;
    _children = widget.initialChildren;
    _infants = widget.initialInfants;
  }

  void _updateCounts({int? adults, int? children, int? infants}) {
    setState(() {
      if (adults != null && adults >= 1) _adults = adults;
      if (children != null && children >= 0) _children = children;
      if (infants != null && infants >= 0) _infants = infants;
    });
    widget.onGuestsChanged(_adults, _children, _infants);
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
            children: [
              Icon(Icons.person_outline_rounded, color: theme.primaryColor, size: 20),
              const SizedBox(width: Dimensions.paddingSizeEight),
              Text(
                "Guests",
                style: textBold.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeTwelve),
          CounterRow(
            title: "Adults",
            subtitle: "Ages 13 or above",
            count: _adults,
            onDecrement: () => _updateCounts(adults: _adults - 1),
            onIncrement: () => _updateCounts(adults: _adults + 1),
            minLimit: 1,
          ),
          Divider(height: Dimensions.paddingSizeLarge, color: theme.colorScheme.outline),
          CounterRow(
            title: "Children",
            subtitle: "Ages 2–12",
            count: _children,
            onDecrement: () => _updateCounts(children: _children - 1),
            onIncrement: () => _updateCounts(children: _children + 1),
            minLimit: 0,
          ),
          Divider(height: Dimensions.paddingSizeLarge, color: theme.colorScheme.outline),
          CounterRow(
            title: "Infants",
            subtitle: "Under 2",
            count: _infants,
            onDecrement: () => _updateCounts(infants: _infants - 1),
            onIncrement: () => _updateCounts(infants: _infants + 1),
            minLimit: 0,
          ),
        ],
      ),
    );
  }
}

class CounterRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final int minLimit;

  const CounterRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
    required this.minLimit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textBold.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              subtitle,
              style: textRegular.copyWith(
                color: theme.hintColor,
                fontSize: Dimensions.fontSizeSmall,
              ),
            ),
          ],
        ),
        Row(
          children: [
            CounterIconButton(
              icon: Icons.remove,
              onPressed: count > minLimit ? onDecrement : null,
            ),
            SizedBox(
              width: 36,
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: textBold.copyWith(
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            CounterIconButton(
              icon: Icons.add,
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}

class CounterIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CounterIconButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isEnabled
                  ? theme.primaryColor
                  : theme.hintColor.withOpacity(0.3),
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isEnabled
                ? theme.primaryColor
                : theme.hintColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
