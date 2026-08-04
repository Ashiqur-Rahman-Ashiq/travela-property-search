import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/domain/models/travela_location_model.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';

class LocationSearchBar extends StatefulWidget {
  final Function(String query) onQueryChanged;
  final Function(TravelaLocationModel location) onLocationSelected;
  final VoidCallback onFilterTap;
  final List<TravelaLocationModel> suggestions;
  final bool isLoadingSuggestions;
  final int appliedFilterCount;

  const LocationSearchBar({
    super.key,
    required this.onQueryChanged,
    required this.onLocationSelected,
    required this.onFilterTap,
    required this.suggestions,
    this.isLoadingSuggestions = false,
    this.appliedFilterCount = 0,
  });

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _showDropdown = _focusNode.hasFocus &&
          widget.suggestions.isNotEmpty &&
          _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void didUpdateWidget(covariant LocationSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.suggestions != oldWidget.suggestions) {
      if (_focusNode.hasFocus &&
          widget.suggestions.isNotEmpty &&
          _controller.text.trim().isNotEmpty) {
        setState(() {
          _showDropdown = true;
        });
      }
    }
  }

  void _onChanged(String text) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    if (text.trim().isEmpty) {
      setState(() {
        _showDropdown = false;
      });
      widget.onQueryChanged('');
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onQueryChanged(text);
      if (mounted) {
        setState(() {
          _showDropdown = _focusNode.hasFocus && text.trim().isNotEmpty;
        });
      }
    });
  }

  void _selectLocation(TravelaLocationModel location) {
    _controller.text = location.name;
    _focusNode.unfocus();
    setState(() {
      _showDropdown = false;
    });
    widget.onLocationSelected(location);
  }

  void _clearInput() {
    _controller.clear();
    widget.onQueryChanged('');
    setState(() {
      _showDropdown = false;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusHundred),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onChanged,
                  style: textRegular.copyWith(color: theme.textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    hintText: "Search location in Bangladesh...",
                    hintStyle: textRegular.copyWith(color: theme.hintColor, fontSize: Dimensions.fontSizeDefault),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: theme.primaryColor,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.isLoadingSuggestions)
                          Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeTwelve),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.primaryColor,
                              ),
                            ),
                          )
                        else if (_controller.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.close, color: theme.hintColor, size: 20),
                            onPressed: _clearInput,
                          ),
                      ],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeTwelve,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Material(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusHundred),
                  child: InkWell(
                    onTap: widget.onFilterTap,
                    borderRadius: BorderRadius.circular(Dimensions.radiusHundred),
                    child: const Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeTwelve),
                      child: Icon(
                        Icons.tune_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                if (widget.appliedFilterCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.appliedFilterCount}',
                          style: textBold.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),

        if (_showDropdown && widget.suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              border: Border.all(color: theme.colorScheme.outline),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: widget.suggestions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: theme.colorScheme.outline,
                ),
                itemBuilder: (context, index) {
                  final location = widget.suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: theme.primaryColor,
                    ),
                    title: Text(
                      location.name,
                      style: textBold.copyWith(
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    subtitle: location.nameBn != null
                        ? Text(
                            location.nameBn!,
                            style: textRegular.copyWith(color: theme.hintColor, fontSize: Dimensions.fontSizeSmall),
                          )
                        : null,
                    onTap: () => _selectLocation(location),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
