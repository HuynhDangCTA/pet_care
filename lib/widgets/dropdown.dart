import 'package:flutter/material.dart';
import 'package:pet_care/widgets/app_text.dart';

class MyDropDownButton extends StatefulWidget {
  final List<DropDownItem> items;
  DropDownItem? value;
  Function(DropDownItem)? onChange;

  MyDropDownButton({super.key, required this.items, this.onChange, this.value});

  @override
  State<MyDropDownButton> createState() => _MyDropDownButtonState();
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  bool _show = false;

  @override
  void initState() {
    widget.value ??= widget.items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            debugPrint('show dropdown');
            setState(() {
              _show = !_show;
            });
          },
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            height: 58,
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
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppText(
                      text: '${widget.value?.text}',
                      size: 16,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.grey,),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        (_show == true)
            ? Container(
                padding: const EdgeInsets.only(left: 10),
                color: Colors.white,
                constraints: const BoxConstraints(
                  minHeight: 100,
                  maxHeight: 500,
                ),
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: AppText(
                        text: widget.items[index].text,
                        size: 16,
                      ),
                      onTap: () {
                        widget.onChange!(widget.items[index]);
                        setState(() {
                          widget.value = widget.items[index];
                          _show = false;
                        });
                      },
                    );
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}

class DropDownItem {
  String? value;
  String text;

  DropDownItem({this.value, this.text = ''});
}
