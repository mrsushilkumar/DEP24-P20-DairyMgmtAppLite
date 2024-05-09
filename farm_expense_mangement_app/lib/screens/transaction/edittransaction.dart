

import 'package:farm_expense_mangement_app/models/transaction.dart';
import 'package:farm_expense_mangement_app/screens/transaction/transactionpage.dart';
import 'package:farm_expense_mangement_app/services/database/transactiondatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditTransaction extends StatefulWidget {
  final bool showIncome;
  final Sale? sale;
  final Expense? expense;
  const EditTransaction({super.key,required this.showIncome,this.sale,this.expense});

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryTransaction;
  late TextEditingController _valueController;

  late DatabaseForSale _dbSale;
  late DatabaseForExpense _dbExpense;
  
  late DateTime _dateOfTransaction;
  
  @override
  initState() {
    super.initState();
    _dbSale = DatabaseForSale(uid: uid);
    _dbExpense = DatabaseForExpense(uid: uid);
    if(widget.showIncome) {
      _categoryTransaction = TextEditingController(text: widget.sale?.name);
      _valueController = TextEditingController(text: widget.sale?.value.toString());
      _dateOfTransaction = widget.sale?.saleOnMonth ?? DateTime.now();
    } else {
      _categoryTransaction = TextEditingController(text: widget.expense?.name);
      _valueController = TextEditingController(text: widget.expense?.value.toString());
      _dateOfTransaction = widget.expense?.expenseOnMonth ?? DateTime.now();
    }
  }
  
  Future<void> editTransactionDatabase() async {
    if(_formKey.currentState!.validate()){
      if (widget.showIncome) {
        final sale = Sale(
            name: _categoryTransaction.text,
            value: double.parse(_valueController.text),
            saleOnMonth: widget.sale?.saleOnMonth);
        return await _dbSale.infoToServerSale(sale);
      } else {
        final expense = Expense(
            name: _categoryTransaction.text,
            value: double.parse(_valueController.text),
            expenseOnMonth: widget.expense?.expenseOnMonth);
        return await _dbExpense.infoToServerExpanse(expense);
      }
    }
  }
  Future<void> deleteSaleDatabase() async {
    await _dbSale.deleteFromServer(widget.sale!);

  }

  Future<void> deleteExpenseDatabase() async {
    await _dbExpense.deleteFromServer(widget.expense!);

  }

  void _submitForm(BuildContext context) {
    editTransactionDatabase();

    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TransactionPage(showIncome: widget.showIncome)));

    // Check if the expiry date is in the past
    if (_dateOfTransaction.isAfter(DateTime.now())) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select a valid expiry date.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    // }
      // else {
    //   editTransactionDatabase();
    //   Navigator.pop(context);
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TransactionPage(showIncome: widget.showIncome)));
    }
  }

  void _deleteTransaction(BuildContext context) {
    if(widget.showIncome) {
      deleteSaleDatabase();
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TransactionPage(showIncome: widget.showIncome)));
    }
    else {
      deleteExpenseDatabase();
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TransactionPage(showIncome: widget.showIncome)));
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        title: Text(
          (widget.showIncome) ? 'Edit Income' : 'Edit Expense',
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  readOnly: true,
                  enabled: false,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  controller: _categoryTransaction,
                  decoration: InputDecoration(
                      labelText: (widget.showIncome) ? 'Income Category' : 'Expense Category',
                      labelStyle: const TextStyle(fontSize: 20, color: Colors.black)),

                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  readOnly: true,
                  enabled: false,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  initialValue: '${_dateOfTransaction.year}-${_dateOfTransaction.month}-${_dateOfTransaction.day}',
                  decoration: const InputDecoration(
                      labelText: 'Transaction Date',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black)),

                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _valueController,
                  decoration: const InputDecoration(labelText: 'Enter Transaction Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 8.0),
              //   padding: const EdgeInsets.all(8.0),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey),
              //     borderRadius: BorderRadius.circular(8.0),
              //   ),
              //   child: TextFormField(
              //     controller: _needController,
              //     decoration: const InputDecoration(labelText: 'Need'),
              //     keyboardType: TextInputType.number,
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter need';
              //       }
              //       if (int.tryParse(value) == null) {
              //         return 'Please enter a valid number';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              // Container(
              //   margin: const EdgeInsets.symmetric(vertical: 8.0),
              //   padding: const EdgeInsets.all(8.0),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Colors.grey),
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              //   child: TextFormField(
              //     controller: _stockController,
              //     decoration: const InputDecoration(labelText: 'Stock'),
              //     keyboardType: TextInputType.number,
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter stock';
              //       }
              //       if (int.tryParse(value) == null) {
              //         return 'Please enter a valid number';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _deleteTransaction(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(13, 166, 186, 0.9)),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitForm(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(13, 166, 186, 0.9)),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
