import 'package:flutter/material.dart';
import 'package:get/get.dart';

errorMessageCustom(String message,
    {Duration duration = const Duration(seconds: 6)}) {
  Get.snackbar(
    "Falha",
    message,
    icon: const Icon(Icons.error_rounded),
    backgroundColor: Colors.red,
  );
}

successMessageCustom(String message,
    {Duration duration = const Duration(seconds: 6)}) {
  Get.snackbar(
    "Sucesso",
    message,
    icon: const Icon(Icons.check_circle_rounded),
    backgroundColor: Colors.green,
  );
}

warningMessageCustom(String message,
    {Duration duration = const Duration(seconds: 6)}) {
  Get.snackbar(
    "Aviso",
    message,
    icon: const Icon(Icons.warning_rounded),
    backgroundColor: Colors.orange,
  );
}

confirmationDialogOperation({
  String title = "Confirmação",
  String message = "Deseja realmente realizar esta operação?",
  IconData icon = Icons.warning_rounded,
  TextStyle? titleStyle,
  TextStyle? messageStyle,
  Color? backgroundColor,
  required BuildContext context,
  Function()? onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            const Icon(
              Icons.warning_rounded,
              color: Colors.orange,
              size: 26,
            ),
            const SizedBox(width: 8),
            Text(title, style: titleStyle),
          ],
        ),
        content: Text(message, style: messageStyle),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (onConfirm != null) {
                onConfirm();
              }
              Navigator.of(context).pop();
            },
            child: const Text('Confirmar'),
          ),
        ],
      );
    },
  );
}
