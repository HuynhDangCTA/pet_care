import 'package:flutter/material.dart';
import 'package:pet_care/util/number_util.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final AutovalidateMode autoValidateMode;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool required;
  final Color textEditColor;
  final Widget? widgetEnd;
  final bool readOnly;
  final Function? onTap;
  final Function(String?)? onChange;
  final bool isCurrency;
  final TextAlign textAlign;

  const MyTextFormField(
      {super.key,
      this.controller,
      this.autoValidateMode = AutovalidateMode.disabled,
      this.validator,
      this.keyboardType = TextInputType.text,
      required this.label,
      this.obscureText = false,
      this.suffixIcon,
      this.required = false,
      this.readOnly = false,
      this.textEditColor = Colors.black,
      this.widgetEnd,
      this.onTap,
      this.onChange,
      this.textAlign = TextAlign.start,
      this.isCurrency = false});

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  String? _error;
  bool _startCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.controller != null && widget.validator != null) {
      widget.controller!.addListener(() {
        setState(() {
          _error = widget.validator!(widget.controller!.text);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            child: TextFormField(
              textAlign: widget.textAlign,
              keyboardType: widget.keyboardType,
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!();
                }
              },
              onChanged: (value) {
                if (widget.onChange != null) {
                  widget.onChange!(value);
                }
                if (widget.isCurrency && widget.controller != null) {
                  String value = widget.controller!.text;
                  if (value.isEmpty) return;
                  String rawValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                  String result = '';
                  int? intValue = int.tryParse(rawValue);
                  if (intValue == null) return;
                  result = NumberUtil.formatCurrencyNotD(intValue);
                  debugPrint('result ' + result);
                  result = result.replaceAll('VND', '').trim();
                  widget.controller!.text = result;
                  widget.controller!.selection = TextSelection.fromPosition(
                      TextPosition(offset: result.length));
                }
                if (_startCheck == false) {
                  setState(() {
                    _startCheck = true;
                  });
                }
              },
              readOnly: widget.readOnly,
              textAlignVertical: TextAlignVertical.top,
              // textAlignVertical: (widget.suffixIcon == null)
              //     ? TextAlignVertical.top
              //     : TextAlignVertical.center,
              validator: widget.validator,
              autovalidateMode: widget.autoValidateMode,
              controller: widget.controller,
              obscureText: widget.obscureText,
              style: TextStyle(
                fontSize: 16,
                color: widget.textEditColor,
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                suffixIcon: Container(
                  width: 10,
                  height: 10,
                  child: widget.suffixIcon,
                ),
                hintText: widget.label,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        ((_error == null || _error!.isEmpty) || _startCheck == false)
            ? Container()
            : const SizedBox(
                height: 5,
              ),
        ((_error == null || _error!.isEmpty) || _startCheck == false)
            ? Container()
            : Text(
                '$_error',
                style: const TextStyle(color: Colors.red, fontSize: 11),
              )
      ],
    );
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.dispose();
    }
    super.dispose();
  }
}
