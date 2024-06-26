import 'package:flutter/material.dart';
import 'package:meter_reader/Utils/common_widgets/app_color.dart';
import 'package:meter_reader/Utils/common_widgets/styles_widget.dart';

class DropdownWidget<T> extends StatelessWidget {
  final T? dropdownValue;
  final String hint;
  final String? label;
  final String? star;
  final void Function(T?)? onChanged;
  final List<T> items;

  const DropdownWidget({
    Key? key,
    required this.dropdownValue,
    required this.onChanged,
    required this.items,
    required this.hint,
    this.label,
    this.star,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
        borderRadius: BorderRadius.circular(5),
        decoration: InputDecoration(
          fillColor: AppColor.black,
          // labelText: label,
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
          enabledBorder: _border(),
          disabledBorder: _border(),
          border: _border(),
          focusedBorder: _border(),
          label: Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(star ?? "", style: Styles.stars)),
                Flexible(
                  child: Text(label ?? "", style: Styles.labels),
                ),
              ],
            ),
          ),
        ),
        hint: Text(hint, style: Styles.labels),
        style: Styles.texts,
        isExpanded: true,
        value: dropdownValue != null ? dropdownValue : null,
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              value.toString(),
              style: Styles.texts,
            ),
          );
        }).toList(),
        onChanged: onChanged);
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 0.80,
        color: AppColor.primer,
      ),
    );
  }
}
