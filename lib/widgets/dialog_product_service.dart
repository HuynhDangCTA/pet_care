import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_care/widgets/app_text.dart';

class DialogProductService extends StatelessWidget {
  final Function onTapItem1;
  final Function onTapItem2;
  const DialogProductService({super.key, required this.onTapItem1, required this.onTapItem2});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              onTapItem1();
            },
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('images/ic_petfood.png'),
                    const SizedBox(
                      height: 10,
                    ),
                    const AppText(
                      text: 'Thêm mới sản phẩm',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              onTapItem2();
            },
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('images/ic_petservice.png'),
                    const SizedBox(
                      height: 10,
                    ),
                    const AppText(
                      text: 'Thêm mới dịch vụ',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
