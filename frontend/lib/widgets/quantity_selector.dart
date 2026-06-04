import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class QuantitySelector extends StatefulWidget {
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final ValueChanged<int> onValueChanged;

  const QuantitySelector({
    super.key,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    required this.onValueChanged,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_resetEmptyValueWhenUnfocused);
  }

  @override
  void didUpdateWidget(QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value &&
        _controller.text != widget.value.toString()) {
      _controller.text = widget.value.toString();
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_resetEmptyValueWhenUnfocused);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _resetEmptyValueWhenUnfocused() {
    if (!_focusNode.hasFocus && _controller.text.isEmpty) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool canDecrement = widget.onDecrement != null;
    final bool canIncrement = widget.onIncrement != null;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : AppColors.bgDark.withValues(alpha: 0.07),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: widget.onDecrement,
            child: Container(
              width: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: canDecrement ? AppColors.primary : Colors.grey.shade400,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: Icon(Icons.remove, color: AppColors.textPrimaryLight),
            ),
          ),
          Expanded(
            child: Center(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                onChanged: (input) {
                  final parsedValue = int.tryParse(input);
                  if (parsedValue != null) {
                    widget.onValueChanged(parsedValue);
                  }
                },
                onSubmitted: (input) {
                  if (input.isEmpty) {
                    _controller.text = widget.value.toString();
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: "HyWenhei",
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: widget.onIncrement,
            child: Container(
              width: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: canIncrement ? AppColors.primary : Colors.grey.shade400,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Icon(Icons.add, color: AppColors.textPrimaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
