import '../../../../ExportFile/export_file.dart';

class MeterNumber extends StatelessWidget {
  final TextEditingController? controller;
  final bool? autoFocus;
  final bool? enabled;
  final TextInputAction? textInputAction;
  final Color? color;
  final ValueChanged? onChanged;
  const MeterNumber(this.controller, this.autoFocus, this.enabled,
      this.textInputAction, this.onChanged, this.color,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: 30,
      child: TextField(
        autofocus: autoFocus == null ? false : autoFocus!,
        enabled: null == enabled ? false : enabled!,
        readOnly: enabled == null
            ? false
            : enabled == true
                ? false
                : true,
        controller: controller,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        textInputAction: textInputAction,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: color ?? Colors.white,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: color ?? Colors.white,
            )),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  color: color ?? Colors.white,
                )),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 8.0)),
      ),
    );
  }
}
