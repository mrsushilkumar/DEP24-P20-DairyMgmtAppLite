import 'package:farm_expense_mangement_app/screens/home/milkavgpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/milk.dart';
import '../../../services/database/milkdatabase.dart';

class MilkByDatePage extends StatefulWidget {
  final DateTime? dateOfMilk;

  const MilkByDatePage({super.key, this.dateOfMilk});

  @override
  State<MilkByDatePage> createState() => _MilkByDatePageState();
}

class _MilkByDatePageState extends State<MilkByDatePage> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late DatabaseForMilk db;

  List<Milk> _allMilkInDate = [];
  List<Milk> _filteredMilk = [];

  @override
  void initState() {
    super.initState();
    db = DatabaseForMilk(uid);
    _fetchAllMilk();
  }

  void _deleteAllMilkOnDate() {
    db.deleteAllMilkRecords(widget.dateOfMilk!);

    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AvgMilkPage()));
  }

  Future<void> _fetchAllMilk() async {
    final DateTime dateTime = widget.dateOfMilk!;
    final snapshot = await db.infoFromServerAllMilk(dateTime);
    setState(() {
      _allMilkInDate =
          snapshot.docs.map((doc) => Milk.fromFireStore(doc, null)).toList();
      _filteredMilk = _allMilkInDate;
    });
  }

  void _searchMilk(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMilk = _allMilkInDate;
      } else {
        _filteredMilk =
            _allMilkInDate.where((milk) => milk.rfid.contains(query)).toList();
      }
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
              onPressed: () {
                _deleteAllMilkOnDate();
              },
              color: Colors.black,
              icon: const Icon(Icons.delete)),
          IconButton(
            color: Colors.black,
            onPressed: () {
              showSearch(
                context: context,
                delegate: MilkSearchDelegate(
                    allMilk: _allMilkInDate, onSearch: _searchMilk),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AvgMilkPage()));
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: Text(
              'Date: ${widget.dateOfMilk!.day}-${widget.dateOfMilk!.month}-${widget.dateOfMilk!.year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 16,
            child: ListView.builder(
              itemCount: _filteredMilk.length,
              itemBuilder: (context, index) {
                final data = _filteredMilk[index];
                return MilkDataRow(data: data);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MilkSearchDelegate extends SearchDelegate<String> {
  final List<Milk> allMilk;
  final Function(String) onSearch;

  MilkSearchDelegate({required this.allMilk, required this.onSearch});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(color: Color.fromRGBO(13, 166, 186, 1)),
      // Customize the search bar's appearance
      inputDecorationTheme: InputDecorationTheme(
        filled: true, // Set to true to add a background color

        fillColor: const Color.fromRGBO(240, 255, 255, 1),
        hintStyle: const TextStyle(fontSize: 18),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black), // Border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black), // Border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.black), // Border color
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = '';
          onSearch('');
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<Milk> searchResults = query.isEmpty
        ? allMilk
        : allMilk.where((milk) => milk.rfid.contains(query)).toList();

    return Container(
      color: const Color.fromRGBO(
          240, 255, 255, 1), // Set the background color here
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final data = searchResults[index];
          return MilkDataRow(data: data);
        },
      ),
    );
  }
}

class MilkDataRow extends StatefulWidget {
  final Milk data;

  const MilkDataRow({super.key, required this.data});

  @override
  State<MilkDataRow> createState() => _MilkDataRowState();
}

class _MilkDataRowState extends State<MilkDataRow> {
  void editDetail() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditMilkByDate(data: widget.data)));
  }

  @override
  Widget build(BuildContext context) {
    final double totalMilk = widget.data.evening + widget.data.morning;

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      color: const Color.fromRGBO(240, 255, 255, 1),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: const BorderSide(
          color: Colors.white,
          width: 3,
        ),
      ),
      child: Row(
        children: [
          // Left container
          Container(
            width: 120,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Rf id: ${widget.data.rfid}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // const SizedBox(height: 5),
                ClipOval(
                  child: Image.asset(
                    'asset/cow1.jpg',
                    fit: BoxFit.cover,
                    width: 80,
                    height: 65,
                  ),
                ),
              ],
            ),
          ),
          // Right container
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'asset/morning.webp',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Morning: ${widget.data.morning.toStringAsFixed(2)}L",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Image.asset(
                        'asset/evening2.jpg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Evening: ${widget.data.evening.toStringAsFixed(2)}L",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Image.asset(
                        'asset/milk.jpg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Total: ${totalMilk}L",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.black,
            onPressed: () {
              editDetail();
            },
          ),
        ],
      ),
    );
  }
}

class EditMilkByDate extends StatefulWidget {
  final Milk data;

  const EditMilkByDate({super.key, required this.data});

  @override
  State<EditMilkByDate> createState() => _EditMilkByDateState();
}

class _EditMilkByDateState extends State<EditMilkByDate> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late DatabaseForMilk db;
  late DatabaseForMilkByDate dbByDate;

  double? milkInMorning;
  double? milkInEvening;

  @override
  void initState() {
    super.initState();
    db = DatabaseForMilk(uid);
    dbByDate = DatabaseForMilkByDate(uid);
    milkInMorning = widget.data.morning;
    milkInEvening = widget.data.evening;
  }

  void _editMilkDetail(Milk milk) async {
    await db.infoToServerMilk(milk);
    final MilkByDate milkByDate;
    final snapshot = await dbByDate.infoFromServerMilk(milk.dateOfMilk!);
    if (snapshot.exists) {
      milkByDate = MilkByDate.fromFireStore(snapshot, null);
    } else {
      milkByDate = MilkByDate(dateOfMilk: milk.dateOfMilk);
      await dbByDate.infoToServerMilk(milkByDate);
    }
    final double totalMilk = milkByDate.totalMilk +
        milk.morning +
        milk.evening -
        widget.data.evening -
        widget.data.morning;
    await dbByDate.infoToServerMilk(
        MilkByDate(dateOfMilk: milk.dateOfMilk, totalMilk: totalMilk));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        title: const Text(
          'Edit Milk Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rf id : ${widget.data.rfid}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Date : ${widget.data.dateOfMilk!.day}-${widget.data.dateOfMilk!.month}-${widget.data.dateOfMilk!.year}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              _buildInputBox(
                labelText: 'Morning Milk (L)',
                initialValue: milkInMorning.toString(),
                onChanged: (value) {
                  setState(() {
                    milkInMorning = double.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 30.0),
              _buildInputBox(
                labelText: 'Evening Milk (L)',
                initialValue: milkInEvening.toString(),
                onChanged: (value) {
                  setState(() {
                    milkInEvening = double.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
                  ),
                  onPressed: () {
                    if (milkInMorning != null && milkInEvening != null) {
                      Milk newMilkData = Milk(
                        rfid: widget.data.rfid,
                        morning: milkInMorning!,
                        evening: milkInEvening!,
                        dateOfMilk: widget.data.dateOfMilk,
                      );
                      _editMilkDetail(newMilkData);
                      Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const AvgMilkPage()));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MilkByDatePage(
                                  dateOfMilk: widget.data.dateOfMilk)));
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox({
    required String labelText,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}
