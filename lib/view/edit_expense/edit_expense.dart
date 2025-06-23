import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/finance/finance_bloc.dart';
import 'package:personal_finance_tracker/models/finance_model.dart';
import 'package:personal_finance_tracker/view/widgets/custom_widgets.dart';

class EditExpenseScreen extends StatefulWidget {
  final Finance expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _type;
  String? _category;
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  final Map<String, List<String>> _categories = {
    'Income': ['Salary', 'Misc'],
    'Expense': ['Food', 'Transport', 'Bills', 'Rent', 'Misc'],
  };

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.expense.description ?? '',
    );
    _type = widget.expense.type;
    _category = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final updatedExpense =
          widget.expense
            ..amount = double.parse(_amountController.text)
            ..category = _category!
            ..type = _type
            ..description = _descriptionController.text
            ..date = _selectedDate!;

      context.read<FinanceBloc>().add(
        UpdateFinanceEvent(finance: updatedExpense),
      );
      Navigator.pushReplacementNamed(context, '/home');
      CustomWidgets().PopUpMsg(msg: "Transaction Updated", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Transaction')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || double.tryParse(value) == null
                            ? 'Enter valid amount'
                            : null,
              ),
              const SizedBox(height: 16),
              Row(
                children:
                    ['Income', 'Expense'].map((type) {
                      return Row(
                        children: [
                          Radio<String>(
                            value: type,
                            groupValue: _type,
                            onChanged:
                                (val) => setState(() {
                                  _type = val!;
                                  _category = null;
                                }),
                          ),
                          Text(type),
                        ],
                      );
                    }).toList(),
              ),
              DropdownButtonFormField<String>(
                value: _category,
                hint: Text("Select Category"),
                items:
                    _categories[_type]!
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _category = val),
                validator: (val) => val == null ? 'Select a category' : null,
              ),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'Pick a date'
                      : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
