import 'package:farm_expense_mangement_app/models/cattle.dart';
import 'package:farm_expense_mangement_app/screens/home/animallist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/database/cattledatabase.dart';
import 'homepage.dart';
import 'localisations_en.dart';
import 'localisations_hindi.dart';
import 'localisations_punjabi.dart';

class AddNewCattle extends StatefulWidget {
  const AddNewCattle({super.key});

  @override
  State<AddNewCattle> createState() => _AddNewCattleState();
}

class _AddNewCattleState extends State<AddNewCattle> {
  late Map<String, String> currentLocalization= {};
  late String languageCode = 'en';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _rfidTextController = TextEditingController();
  final TextEditingController _weightTextController = TextEditingController();
  final TextEditingController _breedTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();

  // final TextEditingController _tagNumberController3 = TextEditingController();

  String? _selectedGender; // Variable to store selected gender
  final TextEditingController _birthDateController = TextEditingController();
  String? _selectedSource;
  String? _selectedState;

  // Variable to store selected gender

  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> sourceOptions = [
    'Born on Farm',
    'Purchased'
  ]; // List of gender options
  final List<String> stateOptions = [
    'Milked',
    'Heifer',
    'Insemination',
    'Abortion',
    'Dry',
    'Calved'
  ];


  void addNewCattleButton(BuildContext context) {

    final cattle = Cattle(
        rfid: _rfidTextController.text,
        age: _ageTextController.text.isNotEmpty
            ? int.parse(_ageTextController.text)
            : 0,
        breed: _breedTextController.text,
        sex: _selectedGender != null ? _selectedGender! : '',
        weight: _weightTextController.text.isNotEmpty
            ? int.parse(_weightTextController.text)
            : 0,
        state: (_selectedGender == 'Female') ? (_selectedState != null ? _selectedState! : '') : 'NA'
    );

    addCattleToDatabase(cattle);

    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AnimalList()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {});
  }

  @override
  void dispose() {
    _rfidTextController.dispose();
    _birthDateController.dispose();
    _weightTextController.dispose();
    _breedTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    languageCode = Provider.of<AppData>(context).persistentVariable;

    if (languageCode == 'en') {
      currentLocalization = LocalizationEn.translations;
    } else if (languageCode == 'hi') {
      currentLocalization = LocalizationHi.translations;
    } else if (languageCode == 'pa') {
      currentLocalization = LocalizationPun.translations;
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      appBar: AppBar(
        title:  Text(
          currentLocalization['new_cattle']??"",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AnimalList()));
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 26),
                child: TextFormField(
                  controller: _rfidTextController,
                  decoration: InputDecoration(
                    labelText: '${currentLocalization['enter_the_rfid'] ?? ""}*',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter tag number';
                    }
                    return null;
                  },
                ),
              ),

              // SizedBox(height: 0.00008),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: '${currentLocalization['gender']??""}*',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                  items: genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text('${currentLocalization[gender.toLowerCase()]??""}*'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select gender';
                    }
                    return null;
                  },
                ),
              ),

              if(_selectedGender == 'Female')
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                  child: DropdownButtonFormField<String>(
                    value: _selectedState,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromRGBO(240, 255, 255, 0.7),
                    ),
                    items: stateOptions.map((String stage) {
                      return DropdownMenuItem<String>(
                        value: stage,
                        child: Text(stage),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedState = value;
                      });
                    },
                  ),
                ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  // initialValue: '0',
                  controller: _ageTextController,
                  decoration:  InputDecoration(
                    labelText: currentLocalization['enter_the_age']??"",

                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  // initialValue: '0',
                  controller: _weightTextController,
                  decoration:  InputDecoration(
                    labelText: '${currentLocalization['enter_the_weight']??""}*',

                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: DropdownButtonFormField<String>(
                    value: _selectedSource,
                    decoration:  InputDecoration(
                      labelText: '${currentLocalization['source_of_cattle']??""}*',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: const Color.fromRGBO(240, 255, 255, 0.7),
                    ),
                    items: sourceOptions.map((String source) {
                      return DropdownMenuItem<String>(
                        value: source,
                        child: Text(currentLocalization[source]??""),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSource = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Source of Cattle';
                      }
                      return null;
                    }),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: TextFormField(
                  controller: _breedTextController,
                  decoration:  InputDecoration(
                    labelText: '${currentLocalization['enter_the_breed']??""}*',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: const Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Breed';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 26),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process the data
                        // For example, save it to a database or send it to an API
                        addNewCattleButton(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                              content: Text(currentLocalization['new_cattle_added_successfully']??"")),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(13, 166, 186, 1.0)),
                    ),
                    child:  Text(
                      currentLocalization['submit']??"",style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
