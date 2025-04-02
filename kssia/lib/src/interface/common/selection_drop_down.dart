import 'package:flutter/material.dart';

class SelectionDropDown extends StatelessWidget {
  final List<DropdownMenuItem<String>> items;
  final String hintText;
  final String? value;
  final ValueChanged<String?> onChanged;

  const SelectionDropDown({
    required this.items,
    this.value,
    required this.onChanged,
    Key? key, required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   label,
          //   style: const TextStyle(fontWeight: FontWeight.bold),
          // ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            hint: Text(hintText),
            value: value,
            items: items, // Pass the DropdownMenuItem list
            onChanged: onChanged,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            iconSize: 16,
          ),
        ],
      ),
    );
  }
}
