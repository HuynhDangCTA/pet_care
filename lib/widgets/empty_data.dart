
import 'package:flutter/material.dart';
import 'package:pet_care/widgets/app_text.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('images/empty_data.png'),
        const AppText(text: 'Không có dữ liệu', color: Colors.grey, size: 16,)
      ],
    );
  }
}
