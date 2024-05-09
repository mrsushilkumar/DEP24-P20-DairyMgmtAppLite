import 'package:farm_expense_mangement_app/models/cattle.dart';
import 'package:farm_expense_mangement_app/screens/home/animaldetails.dart';
import 'package:farm_expense_mangement_app/screens/home/newcattle.dart';
import 'package:farm_expense_mangement_app/services/database/cattledatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnimalList extends StatefulWidget {
  const AnimalList({super.key});

  @override
  State<AnimalList> createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseServicesForCattle cattleDb;
  late List<Cattle> allCattle = [];
  List<String> _selectedStates = [];
  List<String> _selectedGenders = [];

  @override
  void initState() {
    super.initState();
    cattleDb = DatabaseServicesForCattle(uid);
    _fetchCattle();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchCattle() async {
    final snapshot = await cattleDb.infoFromServerAllCattle(uid);
    setState(() {
      allCattle =
          snapshot.docs.map((doc) => Cattle.fromFireStore(doc, null)).toList();
    });
  }

  void viewCattleDetail(Cattle cattle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalDetails(rfid: cattle.rfid),
      ),
    );
  }

  void addCattle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewCattle()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Cattle> filteredCattle = allCattle;

    if (_selectedStates.isNotEmpty) {
      filteredCattle = filteredCattle.where((cattle) {
        for (var state in _selectedStates) {
          if (cattle.state.contains(state)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    if (_selectedGenders.isNotEmpty) {
      filteredCattle = filteredCattle.where((cattle) {
        for (var gender in _selectedGenders) {
          if (cattle.sex.contains(gender)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Cattles',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: AnimalSearchDelegate(allCattle),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_alt,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _showFilterOptions(context);
              });
            },
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
      body: ListView.builder(
        itemCount: filteredCattle.length,
        itemBuilder: (context, index) {
          final cattleInfo = filteredCattle[index];
          return CattleListItem(
            cattle: cattleInfo,
            onTap: () {
              viewCattleDetail(cattleInfo);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCattle(context);
        },
        tooltip: 'Add Cattle',
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Filter Options',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterOption(
                    'State:',
                    [
                      'Milked',
                      'Heifer',
                      'Insemination',
                      'Abortion',
                      'Dry',
                      'Calved'
                    ],
                    _selectedStates,
                    (selectedOptions) {
                      setState(() {
                        _selectedStates = selectedOptions;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFilterOption(
                    'Gender:',
                    ['Male', 'Female'],
                    _selectedGenders,
                    (selectedOptions) {
                      setState(() {
                        _selectedGenders = selectedOptions;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Apply filters here
                          // For demonstration, print the selected options
                          print('Selected States: $_selectedStates');
                          print('Selected Genders: $_selectedGenders');

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.black), // Add border
                        ),
                        child: const Text(
                          'Confirm Filters',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedStates.clear();
                            _selectedGenders.clear();
                          });

                          _fetchCattle(); // Refetch original list
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.black), // Add border
                        ),
                        child: const Text(
                          'Clear Filters',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOption(String title, List<String> options,
      List<String> selectedOptions, Function(List<String>) onSelect) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((option) {
              final isSelected = selectedOptions.contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (isSelected) {
                  List<String> updatedOptions = List.from(selectedOptions);
                  if (isSelected) {
                    setState(() {
                      updatedOptions.add(option);
                    });
                  } else {
                    setState(() {
                      updatedOptions.remove(option);
                    });
                  }
                  onSelect(updatedOptions);
                },
                selectedColor: Colors.lightBlue[100],
                checkmarkColor: Colors.black,
                backgroundColor: Colors.grey.withOpacity(0.3),
                shape: StadiumBorder(
                  side: BorderSide(
                      color: isSelected
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class AnimalSearchDelegate extends SearchDelegate<Cattle> {
  final List<Cattle> allCattle;

  AnimalSearchDelegate(this.allCattle);

  void viewCattleDetail1(BuildContext context, Cattle cattle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalDetails(rfid: cattle.rfid),
      ),
    );
  }

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

        // hintStyle: TextStyle(color: Colors.grey),
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
        close(
          context,
          query.isEmpty
              ? Cattle(rfid: '', breed: '', sex: ' ')
              : Cattle(rfid: '', breed: '', sex: ' '),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = query.isEmpty
        ? allCattle
        : allCattle.where((cattle) => cattle.rfid.contains(query)).toList();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final cattleInfo = searchResults[index];
          return CattleListItem(
            cattle: cattleInfo,
            onTap: () {
              close(context, cattleInfo);
              // Navigate to next page
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = query.isEmpty
        ? allCattle
        : allCattle.where((cattle) => cattle.rfid.contains(query)).toList();

    return Container(
      color: const Color.fromRGBO(
          240, 255, 255, 1), // Set the desired background color here
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final cattleInfo = searchResults[index];
          return CattleListItem(
            cattle: cattleInfo,
            onTap: () {
              viewCattleDetail1(context, cattleInfo);
            },
          );
        },
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Search Cattle';
}

class CattleListItem extends StatefulWidget {
  final Cattle cattle;
  final VoidCallback onTap;

  const CattleListItem({
    required this.cattle,
    required this.onTap,
    super.key,
  });

  @override
  State<CattleListItem> createState() => _CattleListItemState();
}

class _CattleListItemState extends State<CattleListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        color: const Color.fromRGBO(
            240, 255, 255, 1), // Increase top margin for more gap between cards
        elevation: 8, // Increase card elevation for stronger shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(
            color: Colors.white, // Fluorescent color boundary
            width: 3, // Width of the boundary
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(5),
              child: widget.cattle.sex == 'Female'
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                      foregroundDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'asset/cow1.jpg',
                        fit: BoxFit.cover,
                        width: 70, // Adjust width to maximize the size
                        height: 150, // Adjust height to maximize the size
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                      foregroundDecoration:
                          const BoxDecoration(shape: BoxShape.circle),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'asset/Bull1.jpg',
                        fit: BoxFit.cover,
                        width: 70, // Adjust width to maximize the size
                        height: 150, // Adjust height to maximize the size
                      ),
                    ),
            ),
            title: Text(
              'RF id : ${widget.cattle.rfid}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Breed:${widget.cattle.breed}",
                  // style: TextStyle(color: Colors.amber[800]),
                ),
                Text(
                  "Sex:${widget.cattle.sex}",
                  // style: TextStyle(color: Colors.pinkAccent[400]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
