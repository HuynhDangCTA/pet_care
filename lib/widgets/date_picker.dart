import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/util/date_util.dart';
import 'package:pet_care/widgets/app_text.dart';

class DatePicker extends StatefulWidget {
  final String? hintText;
  DateTime selectedDate;
  final Function(DateTime value) onChange;

  DatePicker(
      {super.key,
      this.hintText,
      required this.selectedDate,
      required this.onChange});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: DateTime(1800),
        lastDate: DateTime(2050),
      );
      if (picked != null && picked != widget.selectedDate) {
        widget.onChange(picked);
        setState(() {
          widget.selectedDate = picked;
        });
      }
    }

    return GestureDetector(
      onTap: () {
        debugPrint('on Tap select date');
        _selectDate(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: Get.width,
        height: 58,
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
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              width: 10,
            ),
            AppText(text: '${DateTimeUtil.format(widget.selectedDate)}'),
          ],
        ),
      ),
    );
  }
}
