
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String text;
  final Function(String?) onChange;
  const SearchField({super.key, required this.text, required this.onChange});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10),
          height: 50,
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    // offset: Offset(2, 2),
                    blurRadius: 5,
                    spreadRadius: 1)
              ]),
          child: Center(
            child: TextFormField(
              onChanged: (value) {
                widget.onChange(value);
              },
              textAlignVertical: TextAlignVertical.top,
              // textAlignVertical: (widget.suffixIcon == null)
              //     ? TextAlignVertical.top
              //     : TextAlignVertical.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                suffixIcon: Container(
                  width: 10,
                  height: 10,
                  child: const Icon(Icons.search, color: Colors.grey,),
                ),
                hintText: widget.text,
                border: InputBorder.none,
              ),
            ),
          ),
        )
      ],
    );
  }
}

