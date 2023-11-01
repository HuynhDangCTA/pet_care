import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NumberSelected extends StatefulWidget {
  final Function increase;
  final Function decrease;

  const NumberSelected(
      {super.key, required this.increase, required this.decrease});

  @override
  State<NumberSelected> createState() => _NumberSelectedState();
}

class _NumberSelectedState extends State<NumberSelected> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              widget.decrease();
            },
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                  border:
                      Border(right: BorderSide(color: Colors.grey, width: 1))),
              child: const Icon(
                FontAwesomeIcons.minus,
                size: 15,
              ),
            ),
          ),
          SizedBox(
            height: 25,
            width: 35,
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.increase();
            },
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                  border:
                      Border(left: BorderSide(color: Colors.grey, width: 1))),
              child: const Icon(
                Icons.add,
                size: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
