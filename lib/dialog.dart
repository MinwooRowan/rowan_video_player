import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showExitDialog({required BuildContext context}) async {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('앱을 종료하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('종료'),
            ),
          ],
        );
      });
}
