import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
  });

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        child: transactions.isNotEmpty
            ? ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            'R\$${transactions[index].value}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      DateFormat('d MMM y').format(transactions[index].date),
                    ),
                  );
                },
              )
            : Column(
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
                    height: 200,
                  ),
                ],
              ));
  }
}
