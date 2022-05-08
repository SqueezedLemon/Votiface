import 'package:flutter/material.dart';

void showSuccessDialog(String successText, BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Success'),
      content: Text(
        successText,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(
            'Okay',
          ),
        )
      ],
    ),
  );
}
