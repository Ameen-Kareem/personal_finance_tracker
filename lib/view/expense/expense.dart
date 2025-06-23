import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/blocs/authentication/authentication_bloc.dart';
import 'package:personal_finance_tracker/blocs/finance/finance_bloc.dart';
import 'package:personal_finance_tracker/view/expense/expense.dart';
import 'package:personal_finance_tracker/view/widgets/custom_widgets.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _type = 'Income';
  String? _category;
  DateTime? _selectedDate;

  final Map<String, List<String>> _categories = {
    'Income': ['Salary', 'Misc'],
    'Expense': ['Food', 'Transport', 'Bills', 'Rent', 'Misc'],
  };
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      context.read<FinanceBloc>().add(
        AddFinanceEvent(
          type: _type,
          amount: double.parse(_amountController.text),
          category: _category!,
          date: _selectedDate!,
          description: _descriptionController.text,
        ),
      );
      Navigator.pop(context);
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please pick a date')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomWidgets().CustomTextField(
                controller: _amountController,
                inputType: TextInputType.number,
                labelText: "Amount",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children:
                    ['Income', 'Expense'].map((type) {
                      return Row(
                        children: [
                          Radio<String>(
                            value: type,
                            groupValue: _type,
                            onChanged: (value) {
                              setState(() {
                                _type = value!;
                                _category = null;
                              });
                            },
                          ),
                          Text(type),
                        ],
                      );
                    }).toList(),
              ),
              SizedBox(height: 16),
              CustomWidgets().CustomDropDownButton(
                currentValue: _category,
                validator:
                    (value) =>
                        value == null ? 'Please select a category' : null,
                labelText: 'Category',
                values:
                    _categories[_type]!
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChangedfunctionality:
                    (value) => setState(() => _category = value),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'Pick a date'
                      : 'Date:     ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDate(context),
              ),
              SizedBox(height: 16),
              CustomWidgets().CustomTextField(
                controller: _descriptionController,
                labelText: 'Description / Notes (optional)',
                maxLines: 3,
              ),
              SizedBox(height: 24),
              CustomWidgets().CustomButton(
                functionality: _submitForm,
                text: 'Submit',
                maxHeight: 50,
                maxWidth: double.infinity,
                minHeight: 50,
                minWidth: double.infinity,
              ),
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is LoggedOutState) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.pushReplacementNamed(context, '/login');
                    });
                  }
                },
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
