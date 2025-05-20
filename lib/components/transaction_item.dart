import 'dart:math';

import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.onUpdate,
    required this.tr,
    required this.onRemove,
  });

  final void Function(BuildContext, Transaction) onUpdate;
  final Transaction tr;
  final void Function(String) onRemove;

  Color _getRandomColor(String input) {
    final random = Random(input.hashCode);
    return Color.fromARGB(
      255,
      100 + random.nextInt(155),
      100 + random.nextInt(155),
      100 + random.nextInt(155),
    );
  }

  @override
  Widget build(BuildContext context) {
    final randomColor = _getRandomColor(tr.id);

    return ListTile(
      onTap: () => onUpdate(context, tr),
      onLongPress: () => showDialog(
        context: context,
        builder: (context) {
          return AlertConfirmation(onRemove: onRemove, tr: tr);
        },
      ),
      leading: CircleAvatar(
        backgroundColor: randomColor,
        radius: 30,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: FittedBox(
            child: Text(
              'R\$${tr.value.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      title: Text(
        tr.title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(
        DateFormat('d MMM y').format(tr.date),
      ),
    );
  }
}

class AlertConfirmation extends StatelessWidget {
  const AlertConfirmation({
    super.key,
    required this.onRemove,
    required this.tr,
  });

  final void Function(String) onRemove;
  final Transaction tr;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Excluir'),
      content: const Text("Tem certeza de que quer excluir esta despesa?"),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Sim'),
          onPressed: () {
            onRemove(tr.id);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Não'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
