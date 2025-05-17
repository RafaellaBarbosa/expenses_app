import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    required this.onRemove,
    required this.onUpdate,
  });

  final List<Transaction> transactions;
  final void Function(String) onRemove;
  final void Function(BuildContext, Transaction) onUpdate;

  @override
  Widget build(BuildContext context) {
    return transactions.isNotEmpty
        ? ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (BuildContext context, int index) {
              final tr = transactions[index];
              return ListTile(
                onTap: () => onUpdate(context, tr),
                onLongPress: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertConfirmation(onRemove: onRemove, tr: tr);
                  },
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.purple,
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: FittedBox(
                      child: Text(
                        'R\$${tr.value}',
                        style: const TextStyle(color: Colors.white),
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
            },
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Nenhuma Transação Cadastrada",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                    height: constraints.maxHeight * 0.6,
                  ),
                ],
              );
            },
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
