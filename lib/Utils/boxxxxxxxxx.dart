// zero-width space character
import 'package:flutter/material.dart';

///
/// this character can be added to a string to detect backspace.
/// The value, from its name, has a zero-width so it's not rendered
/// in the screen but it'll be present in the String.
///
/// The main reason this value is used because in Flutter mobile,
/// backspace is not detected when there's nothing to delete.
const zwsp = '\u200b';

// the selection is at offset 1 so any character is inserted after it.
const zwspEditingValue = TextEditingValue(
    text: zwsp, selection: TextSelection(baseOffset: 1, extentOffset: 1));

class CodeField extends StatefulWidget {
  const CodeField({Key? key}) : super(key: key);

  @override
  _CodeFieldState createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> {
  List<String> code = ['', '', '', '', '', '', '', '', '', ''];

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNodes = List.generate(10, (index) => FocusNode());
    controllers = List.generate(10, (index) {
      final ctrl = TextEditingController();
      ctrl.value = zwspEditingValue;
      return ctrl;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // give the focus to the first node.
      focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNodes.forEach((focusNode) {
      focusNode.dispose();
    });
    controllers.forEach((controller) {
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        10,
        (index) {
          return Container(
            width: 15,
            height: 20,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              maxLength: 2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                counterText: "",
              ),
              onChanged: (value) {
                if (value.length > 1) {
                  // this is a new character event
                  if (index + 1 == focusNodes.length) {
                    // do something after the last character was inserted
                    FocusScope.of(context).unfocus();
                  } else {
                    // move to the next field
                    focusNodes[index + 1].requestFocus();
                  }
                } else {
                  // this is backspace event

                  // reset the controller
                  controllers[index].value = zwspEditingValue;
                  if (index == 0) {
                    // do something if backspace was pressed at the first field
                  } else {
                    // go back to previous field
                    controllers[index - 1].value = zwspEditingValue;
                    focusNodes[index - 1].requestFocus();
                  }
                }
                // make sure to remove the zwsp character
                code[index] = value.replaceAll(zwsp, '');
                print('current code = $code');
              },
            ),
          );
        },
      ),
    );
  }
}
