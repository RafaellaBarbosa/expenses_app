import 'package:expenses_app/components/adaptative_button.dart';
import 'package:expenses_app/components/adaptative_date_picker.dart';
import 'package:expenses_app/components/adaptative_text_field.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({
    super.key,
    required this.onSubmit,
  });

  final void Function(String, double, DateTime) onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              10.0, 10, 10, 10 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdaptativeTextField(
                label: "Título",
                controller: titleController,
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _submitForm,
                textInputAction: TextInputAction.next,
              ),
              AdaptativeTextField(
                label: "Valor (R\$)",
                controller: valueController,
                textInputAction: TextInputAction.done,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) {
                  _submitForm;
                },
              ),
              AdaptativeDatePicker(
                selectedDate: _selectedDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              AdaptativeButton(
                onPressed: () {
                  _submitForm();
                },
                label: "Nova Transação",
              )
            ],
          ),
        ),
      ),
    );
  }

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text);

    if (title.isEmpty || value == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate);
  }
}
