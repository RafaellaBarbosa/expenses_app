import 'dart:math';

import 'package:expenses_app/components/transaction_form.dart';
import 'package:expenses_app/components/transaction_list.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionUser extends StatefulWidget {
  const TransactionUser(
      {super.key,
      required this.titleController,
      required this.valueController,
      this.onChanged});

  final TextEditingController titleController;
  final TextEditingController valueController;
  final void Function(String)? onChanged;

  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextInt.toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );
    setState(() {
      _transactions.add(newTransaction);
    });
  }

  final _transactions = [
    Transaction(
      id: "1",
      title: "Compra de alimentos",
      value: 50.0,
      date: DateTime.now(),
    ),
    Transaction(
      id: "2",
      title: "Pagamento de conta de luz",
      value: 80.0,
      date: DateTime(2023, 11, 25),
    ),
    Transaction(
      id: "3",
      title: "Recebimento de salário",
      value: 2000.0,
      date: DateTime(2023, 11, 15),
    ),
    Transaction(
      id: "4",
      title: "Compra online",
      value: 120.0,
      date: DateTime(2023, 11, 10),
    ),
    Transaction(
      id: "5",
      title: "Retirada no caixa eletrônico",
      value: 100.0,
      date: DateTime(2023, 11, 5),
    ),
    Transaction(
      id: "6",
      title: "Depósito em conta",
      value: 300.0,
      date: DateTime(2023, 10, 30),
    ),
    Transaction(
      title: "Compras de eletrônicos",
      value: 1200.0,
      date: DateTime(2023, 11, 23),
      id: '7',
    ),
    Transaction(
      title: "Aluguel",
      value: 800.0,
      date: DateTime(2023, 11, 1),
      id: '',
    ),
    Transaction(
      id: '',
      title: "Restaurante",
      value: 70.0,
      date: DateTime(2023, 10, 28),
    ),
    Transaction(
      id: '',
      title: "Presente de aniversário",
      value: 50.0,
      date: DateTime(2023, 10, 15),
    ),
    Transaction(
      id: '',
      title: "Assinatura mensal",
      value: 15.0,
      date: DateTime(2023, 9, 30),
    ),
    Transaction(
      id: '',
      title: "Gás de cozinha",
      value: 60.0,
      date: DateTime(2023, 9, 22),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionForm(onSubmit: _addTransaction),
        TransactionList(transactions: _transactions),
      ],
    );
  }
}
