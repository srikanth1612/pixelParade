import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quickalert/quickalert.dart';

showAlertWithDialouge(BuildContext context, String message,
    final Function(String value) onSubmit) {
  return QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    text:
        "Give us your email and we will notify about new exclusive original stickers",
    barrierDismissible: true,
    confirmBtnText: 'Save',
    showCancelBtn: true,
    customAsset: "assets/images/email_icon.gif",
    headerBackgroundColor: HexColor("b0fafc"),
    widget: TextFormField(
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        hintText: 'Email',
        prefixIcon: Icon(
          Icons.email,
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => message = value,
    ),
    onCancelBtnTap: () {
      onSubmit(message);
    },
    onConfirmBtnTap: () async {
      if (message.length < 5) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Invalid Email',
        );
        return;
      } else if (validateEmail(message) == null) {
        onSubmit(message);
        return;
      } else {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Invalid Email',
        );
        return;
      }
    },
  );
}

String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isEmpty || !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
}

showAlertMessage(BuildContext context, String message) {
  return QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: "Info",
      text: message);
}
