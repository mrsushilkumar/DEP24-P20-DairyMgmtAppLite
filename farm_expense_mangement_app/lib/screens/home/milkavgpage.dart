import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/cattle.dart';
import '../../models/milk.dart';
import '../../services/database/cattledatabase.dart';
import '../../services/database/milkdatabase.dart';
import 'milk/milkbydate.dart';

class AvgMilkPage extends StatefulWidget {
  const AvgMilkPage({super.key});

  @override
  State<AvgMilkPage> createState() => _AvgMilkPageState();
}

class _AvgMilkPageState extends State<AvgMilkPage> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseForMilkByDate db;
  List<MilkByDate> _allMilkByDate = [];
  late DateTime _selectedDate = DateTime.now();
  List<MilkByDate> _originalMilkByDate = [];
  bool _isLoading = true;

  Future<void> _fetchAllMilkByDate() async {
    final snapshot = await db.infoFromServerAllMilk();
    setState(() {
      _originalMilkByDate = snapshot.docs
          .map((doc) => MilkByDate.fromFireStore(doc, null))
          .toList();
      _allMilkByDate = _originalMilkByDate;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    db = DatabaseForMilkByDate(uid);
    _fetchAllMilkByDate();
  }

  void _resetList() {
    setState(() {
      _allMilkByDate = _originalMilkByDate;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _filterMilkByDate(_selectedDate);
    }
  }

  void _filterMilkByDate(DateTime selectedDate) {
    setState(() {
      _allMilkByDate = _originalMilkByDate
          .where((milk) => milk.dateOfMilk == selectedDate)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        title: const Center(
          child: Text(
            'Milk Records',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {
              if (_allMilkByDate.length != _originalMilkByDate.length) {
                _resetList();
              } else {
                _selectDate(context);
              }
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _allMilkByDate.isEmpty
              ? const Center(
                  child: Text(
                    'No entries found for selected date.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _allMilkByDate.length,
                  itemBuilder: (context, index) {
                    return MilkDataRowByDate(data: _allMilkByDate[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMilkDataPage(
                onMilkRecordAdded: () {
                  _fetchAllMilkByDate();
                },
              ),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMilkDataPage extends StatefulWidget {
  final VoidCallback? onMilkRecordAdded;

  const AddMilkDataPage({super.key, this.onMilkRecordAdded});

  @override
  State<AddMilkDataPage> createState() => _AddMilkDataPageState();
}

class _AddMilkDataPageState extends State<AddMilkDataPage> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseForMilk db;
  late DatabaseForMilkByDate dbByDate;
  late DatabaseServicesForCattle cattleDb;

  List<Cattle> allCattle = [];
  List<String> allRfid = [];

  Future<void> _fetchCattle() async {
    final snapshot = await cattleDb.infoFromServerAllCattle(uid);
    setState(() {
      allCattle =
          snapshot.docs.map((doc) => Cattle.fromFireStore(doc, null)).toList();
      allRfid = allCattle.map((cattle) => cattle.rfid).toList();
    });
  }

  String? selectedRfid;
  double? milkInMorning;
  double? milkInEvening;
  DateTime? milkingDate;

  @override
  void initState() {
    super.initState();
    db = DatabaseForMilk(uid);
    dbByDate = DatabaseForMilkByDate(uid);
    cattleDb = DatabaseServicesForCattle(uid);
    _fetchCattle();
  }

  Future<void> _addMilk(Milk data) async {
    await db.infoToServerMilk(data);
    final snapshot = await dbByDate.infoFromServerMilk(data.dateOfMilk!);
    final MilkByDate milkByDate;
    if (snapshot.exists) {
      milkByDate = MilkByDate.fromFireStore(snapshot, null);
    } else {
      milkByDate = MilkByDate(dateOfMilk: data.dateOfMilk);
      await dbByDate.infoToServerMilk(milkByDate);
    }
    final double totalMilk = milkByDate.totalMilk + data.morning + data.evening;
    await dbByDate.infoToServerMilk(
        MilkByDate(dateOfMilk: data.dateOfMilk, totalMilk: totalMilk));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        title: const Text(
          'Add Milk Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedRfid,
                decoration: const InputDecoration(
                  labelText: 'Select RFID',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromRGBO(240, 255, 255, 0.7),
                ),
                items: allRfid.map((String rfid) {
                  return DropdownMenuItem<String>(
                    value: rfid,
                    child: Text(rfid),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRfid = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select RFID';
                  }
                  return null;
                },
                dropdownColor: const Color.fromRGBO(240, 255, 255, 1),
              ),
              const SizedBox(height: 20.0),
              _buildInputBox(
                child: TextFormField(
                  onChanged: (value) {
                    milkInMorning = double.tryParse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Morning Milk',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildInputBox(
                child: TextFormField(
                  onChanged: (value) {
                    milkInEvening = double.tryParse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Evening Milk',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildInputBox(
                child: InkWell(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        milkingDate = pickedDate;
                      });
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: milkingDate != null
                            ? '${milkingDate!.year}-${milkingDate!.month}-${milkingDate!.day}'
                            : '',
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Milking Date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
                  ),
                  onPressed: () {
                    if (selectedRfid != null && milkingDate != null) {
                      final Milk newMilkData = Milk(
                        rfid: selectedRfid!,
                        morning: milkInMorning!,
                        evening: milkInEvening!,
                        dateOfMilk: milkingDate,
                      );

                      _addMilk(newMilkData).then((_) {
                        if (widget.onMilkRecordAdded != null) {
                          widget.onMilkRecordAdded!();
                        }
                        Navigator.pop(context);
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('Add',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
      child: child,
    );
  }
}

class MilkDataRowByDate extends StatefulWidget {
  final MilkByDate data;

  const MilkDataRowByDate({super.key, required this.data});

  @override
  State<MilkDataRowByDate> createState() => _MilkDataRowByDateState();
}

class _MilkDataRowByDateState extends State<MilkDataRowByDate> {
  void viewMilkByDate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MilkByDatePage(dateOfMilk: (widget.data.dateOfMilk)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        viewMilkByDate();
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        color: const Color.fromRGBO(240, 255, 255, 1),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                foregroundDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'asset/milk.jpg',
                  fit: BoxFit.cover,
                  width: 70,
                  height: 200,
                ),
              ),
            ),
            title: Text(
              "Date: ${widget.data.dateOfMilk?.day}-${widget.data.dateOfMilk?.month}-${widget.data.dateOfMilk?.year}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Text(
                  "Total Milk: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.data.totalMilk.toStringAsFixed(2)}L",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
