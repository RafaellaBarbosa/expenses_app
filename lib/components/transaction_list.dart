import 'package:expenses_app/components/transaction_item.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';

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
              return TransactionItem(
                  onUpdate: onUpdate, tr: tr, onRemove: onRemove);
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

