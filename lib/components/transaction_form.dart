import 'package:expenses_app/components/adaptative_text_field.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String title, double value, DateTime date)? onSubmit;
  final void Function(Transaction transaction)? onUpdate;
  final Transaction? transaction;

  const TransactionForm({
    super.key,
    this.onSubmit,
    this.onUpdate,
    this.transaction,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _valueController.text = widget.transaction!.value.toString();
      _selectedDate = widget.transaction!.date;
    }
  }

  void _submitForm() {
    final title = _titleController.text.trim();
    final value =
        double.tryParse(_valueController.text.replaceAll(',', '.')) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) return;

    if (widget.transaction != null && widget.onUpdate != null) {
      final updated = widget.transaction!.copyWith(
        title: title,
        value: value,
        date: _selectedDate!,
      );
      widget.onUpdate!(updated);
    } else if (widget.onSubmit != null) {
      widget.onSubmit!(title, value, _selectedDate!);
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    ).then((pickedDate) {
      if (pickedDate == null) return;

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + bottomInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdaptativeTextField(
                controller: _titleController,
                label: 'Título',
                onSubmitted: (_) => _submitForm(),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              AdaptativeTextField(
                controller: _valueController,
                label: 'Valor (R\$)',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitForm(),
                textInputAction: TextInputAction.done,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma data selecionada!'
                          : 'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(isEditing ? 'Atualizar' : 'Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
