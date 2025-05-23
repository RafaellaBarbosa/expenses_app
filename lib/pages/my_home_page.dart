import 'package:expenses_app/components/chart.dart';
import 'package:expenses_app/components/transaction_form.dart';
import 'package:expenses_app/components/transaction_list.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];
  bool showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: const Uuid().v4(),
      title: title,
      value: value,
      date: date,
    );
    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  void _updateTransaction(
    Transaction transaction,
  ) {
    setState(() {
      final index = _transactions.indexWhere((tr) => tr.id == transaction.id);
      if (index >= 0) {
        _transactions[index] = _transactions[index].copyWith(
          title: transaction.title,
          value: transaction.value,
          date: transaction.date,
        );
      }
    });
    Navigator.of(context).pop();
  }

  void _openTransactionFormModal(BuildContext context,
      [Transaction? transaction]) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return TransactionForm(
          onSubmit: transaction == null ? _addTransaction : null,
          onUpdate: transaction != null ? _updateTransaction : null,
          transaction: transaction,
        );
      },
    );
  }

  void _openTransactionEditFormModal(
      BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (_) {
        return TransactionForm(
          transaction: transaction,
          onUpdate: _updateTransaction,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text("Despesas Pessoais"),
      actions: [
        if (isLandscape)
          IconButton(
            onPressed: () {
              setState(() {
                showChart = !showChart;
              });
            },
            icon: Icon(showChart ? Icons.list : Icons.pie_chart),
          ),
        IconButton(
          onPressed: () => _openTransactionFormModal(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
    final avaibleHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showChart || !isLandscape)
                SizedBox(
                  height: avaibleHeight * (isLandscape ? 0.7 : 0.3),
                  child: Chart(recentTransaction: _recentTransactions),
                ),
              if (!showChart || !isLandscape)
                SizedBox(
                  height: avaibleHeight * 0.75,
                  child: TransactionList(
                    transactions: _transactions,
                    onRemove: _removeTransaction,
                    onUpdate: _openTransactionEditFormModal,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          _openTransactionFormModal(context);
        },
        isExtended: true,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
