
import 'dart:async';

import 'package:farm_expense_mangement_app/screens/home/animallist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cattle.dart';
import '../../services/database/cattledatabase.dart';
import 'package:farm_expense_mangement_app/models/history.dart';
import 'package:farm_expense_mangement_app/services/database/cattlehistorydatabase.dart';
import '../../main.dart';
import 'homepage.dart';
import 'localisations_en.dart';
import 'localisations_hindi.dart';
import 'localisations_punjabi.dart';
class AnimalDetails extends StatefulWidget {
  final String rfid;
  const AnimalDetails({super.key, required this.rfid});

  @override
  State<AnimalDetails> createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<AnimalDetails> {
  late Map<String, String> currentLocalization= {};
  late String languageCode = 'en';

  late Stream<Cattle> _streamController;

  // late DocumentSnapshot<Map<String,dynamic>> snapshot;
  late Cattle _cattle;

  late List<CattleHistory> events = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCattleHistory();

    _streamController = _fetchCattleDetail();
  }

  Stream<Cattle> _fetchCattleDetail() {

    return getCattleDetailFromDatabase(widget.rfid).asStream();
  }

  Future<void> _fetchCattleHistory() async {
    final snapshot = await getCattleHistory(widget.rfid);
    setState(() {
      events = snapshot;
    });
  }

  void editCattleDetail() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditAnimalDetail(cattle: _cattle)));
  }

  void deleteCattle() {
    deleteCattleFromDatabase(widget.rfid);
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AnimalList()));
  }

  bool isDetailVisible = false;
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
    Widget buildWidget(CattleHistory event) {
      if (event.name == currentLocalization['abortion']) {
        return Image.asset(
          'asset/Cross_img.png',
          width: 30,
          height: 35,
        );
      } else if (event.name == currentLocalization['Vaccination']) {
        return Image.asset(
          'asset/Vaccination.png',
          width: 30,
          height: 35,
        );
      } else if (event.name == currentLocalization['Heifer']) {
        return Image.asset(
          'asset/heifer.png',
          width: 30,
          height: 35,
        );
      } else {
        return Image.asset(
          'asset/Vaccination.png',
          width: 30,
          height: 35,
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1.0),
      appBar: AppBar(
        title: Text(
          widget.rfid,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                deleteCattle();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                editCattleDetail();
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              )),
        ],
      ),
      body: StreamBuilder(
          stream: _streamController,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: Text(currentLocalization['please_wait']??""),
              );
            } else if (snapshot.hasData) {
              _cattle = snapshot.requireData;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            currentLocalization['events']??"",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AddEventPopup(cattle: _cattle,refresh: (){
                                      _fetchCattleHistory();
                                    },);
                                  },
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(240, 255, 255, 1.0),
                                ),
                                side: MaterialStateProperty.all<BorderSide>(
                                  const BorderSide(
                                      color: Colors
                                          .black), // Set the border color here
                                ),
                              ),
                              child: Text(
                                currentLocalization['add_event']??"",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    // child:SingleChildScrollView(
                    //   scrollDirection: Axis.vertical,
                    child: ListView(
                      children: events
                          .map((event) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 7, 10, 7),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors
                                            .grey, // Set the border color here
                                        width: 1.5, // Set the border width here
                                      ),
                                      color: const Color.fromRGBO(
                                          240, 255, 255, 1)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 10, 10, 10),
                                            width: 130,
                                            height: 60,
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: buildWidget(event)),
                                      ),
                                      Expanded(
                                        flex: 12,
                                        child: Text(
                                          " ${capitalizeFirstLetterOfEachWord(currentLocalization[event.name.toLowerCase()]??"")}",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: SizedBox(
                                          // width: 80,
                                          child: Text(
                                            "${event.date.year}-${(event.date.month >9)? event.date.month : '0${event.date.month}'}-${(event.date.day >9)? event.date.day : '0${event.date.day}'}", // Display the raw date string
                                            softWrap: false,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    // ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                    child: Center(
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              isDetailVisible
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              color: const Color.fromRGBO(13, 166, 186, 1),
                              size: 40,
                            ),
                            onPressed: () {
                              setState(() {
                                isDetailVisible =
                                    !isDetailVisible; // Toggle visibility
                              });
                            },
                          ),
                           Padding(
                            padding: EdgeInsets.fromLTRB(12.0, 8, 12, 2),
                            child: Text(
                              currentLocalization["details"]??"",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromRGBO(13, 166, 186, 1.0),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                    // color: Colors.grey[200],
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: isDetailVisible
                        ? 300
                        : 0, // Set height based on visibility
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              color: const Color.fromRGBO(13, 166, 186, 1.0),
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                   SizedBox(
                                    width: 100,
                                    child: Text(
                                      currentLocalization["age"]??"",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "${_cattle.age}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              color: const Color.fromRGBO(13, 166, 186, 1.0),
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                   SizedBox(
                                    width: 100,
                                    child: Text(
                                      currentLocalization["sex"]??"",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      currentLocalization[_cattle.sex.toLowerCase()]??"",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              color: const Color.fromRGBO(13, 166, 186, 1.0),
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                   SizedBox(
                                    width: 100,
                                    child: Text(
                                      currentLocalization["weight"]??"",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "${_cattle.weight}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 50,
                              color: const Color.fromRGBO(13, 166, 186, 1.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                   SizedBox(
                                    width: 100,
                                    child: Text(
                                      currentLocalization["breed"]??"",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      _cattle.breed,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 50,
                              color: const Color.fromRGBO(13, 166, 186, 1.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                   SizedBox(
                                    width: 100,
                                    child: Text(
                                      currentLocalization["state"]??"",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      currentLocalization[_cattle.state.toLowerCase()]??"",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 60,
                              color: const Color.fromRGBO(13, 166, 186, 1.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                   SizedBox(
                                    width: 100,
                                    child: Text(
                                      currentLocalization["source_of_cattle"]??"",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      _cattle.source,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Error in fetch'),
              );
            }
          }),
    );
  }
}

class EditAnimalDetail extends StatefulWidget {
  final Cattle cattle;

  const EditAnimalDetail({super.key, required this.cattle});

  @override
  State<EditAnimalDetail> createState() => _EditAnimalDetailState();
}

class _EditAnimalDetailState extends State<EditAnimalDetail> {
  late Map<String, String> currentLocalization= {};
  late String languageCode = 'en';

  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _rfidTextController = TextEditingController();
  final TextEditingController _weightTextController = TextEditingController();
  final TextEditingController _breedTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();

  // final TextEditingController _tagNumberController3 = TextEditingController();

  String? _selectedGender; // Variable to store selected gender
  final TextEditingController _birthDateController = TextEditingController();
  String? _selectedSource;
  String? _selectedStage;

  // Variable to store selected gender

  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> sourceOptions = [
    'Born on Farm',
    'Purchased'
  ]; // List of gender options
  final List<String> stageOptions = [
    'Milked',
    'Heifer',
    'Insemination',
    'Abortion',
    'Dry',
    'Calved'
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedGender = widget.cattle.sex;
    _selectedStage = widget.cattle.state;
    _selectedSource = widget.cattle.source;
    _breedTextController.text = widget.cattle.breed;
    _weightTextController.text = widget.cattle.weight.toString();
    _ageTextController.text = widget.cattle.age.toString();
  }

  void updateCattleButton(BuildContext context) {
    final cattle = Cattle(
        rfid: widget.cattle.rfid,
        age: 4,
        breed: _breedTextController.text,
        sex: _selectedGender.toString(),
        weight: int.parse(_weightTextController.text),
        state: _selectedStage.toString());

    updateCattleInDatabase(cattle);

    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AnimalDetails(
                  rfid: widget.cattle.rfid,
                )));
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
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1.0),
      appBar: AppBar(
        title:  Text(
          currentLocalization['Edit Details']??"",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(13, 166, 186, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AnimalDetails(rfid: widget.cattle.rfid)));
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
                padding: const EdgeInsets.fromLTRB(5, 8, 5, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    labelText: '${currentLocalization['gender']??""}*',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                  items: genderOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(currentLocalization[gender.toLowerCase()]??""),
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
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 26),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  // initialValue: '0',
                  controller: _ageTextController,
                  decoration:  InputDecoration(
                    labelText: '${currentLocalization['enter_the_age']??""}',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 26),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _weightTextController,
                  decoration: InputDecoration(
                    labelText: '${currentLocalization['enter_the_weight']??""}',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedSource,
                  decoration: InputDecoration(
                    labelText: '${currentLocalization['source_of_cattle']??""}*',

                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                  items: sourceOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(currentLocalization[gender]??""),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSource = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Source';
                    }
                    return null;
                  },
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 26),
                child: TextFormField(
                  controller: _breedTextController,
                  decoration:  InputDecoration(
                    labelText: '${currentLocalization['enter_the_breed']??""}*',

                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Breed';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 26),
                child: DropdownButtonFormField<String>(
                  value: _selectedStage,
                  decoration:  InputDecoration(
                    labelText: currentLocalization['status']??"",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromRGBO(240, 255, 255, 0.7),
                  ),
                  items: stageOptions.map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(currentLocalization[gender.toLowerCase()]??""),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStage = value;
                    });
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
                        updateCattleButton(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                              content: Text(
                                  currentLocalization['Cattle Details updated Successfully!!']??"",
                              )
                        )
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(13, 166, 186, 1.0),
                      ),
                    ),
                    child:  Text(
                      currentLocalization['submit']??"",
                      style: TextStyle(
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

  @override
  void dispose() {
    // _rfidTextController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }
}

String capitalizeFirstLetterOfEachWord(String input) {
  if (input.isEmpty) return "";

  var words = input.toLowerCase().split(' ');
  for (int i = 0; i < words.length; i++) {
    words[i] = words[i][0].toUpperCase() + words[i].substring(1);
  }
  return words.join(' ');
}

class AddEventPopup extends StatefulWidget {
  final Cattle cattle;
  final Function refresh;

  const AddEventPopup({
    super.key,
    required this.cattle,
    required this.refresh
  });

  @override
  State<AddEventPopup> createState() => _AddEventPopupState();
}

class _AddEventPopupState extends State<AddEventPopup> {
  late Map<String, String> currentLocalization= {};
  late String languageCode = 'en';

  String? selectedOption;
  List<String> eventOptionsFemale = [
    'Abortion',
    'Vaccination',
    'Heifer',
    'Insemination'
  ];
  List<String> eventOptionsMale = [
    'Vaccination',
  ];
  DateTime? selectedDate;

  List<String> eventNameOption = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    eventNameOption = (widget.cattle.sex == 'Female') ? eventOptionsFemale : eventOptionsMale;

  }

  // final AnimalDetails detail=AnimalDetails(rfid);

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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Future addNewCattleHistory(CattleHistory cattleHistory) async {
    await addCattleHistoryToDatabase(cattleHistory);
    widget.refresh();
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           Text(
            currentLocalization['Add Event']??"",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<String>(
              value: selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
              },
              decoration:  InputDecoration(
                hintText: currentLocalization['Event Name']??"",
                border: OutlineInputBorder(),
              ),
              items: eventNameOption.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(currentLocalization[option.toLowerCase()]??""),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            readOnly: true,
            controller: TextEditingController(
                text: selectedDate != null
                    ? selectedDate.toString().split(' ')[0]
                    : ''),
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            decoration:  InputDecoration(
              hintText: currentLocalization['Event Date']??"",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (selectedOption != null && selectedDate != null) {
                // Create a new history entry
                // final dateWithoutTime = DateTime(selectedDate.year, date.month, date.day);
                final newHistory = CattleHistory(
                  rfid: widget.cattle.rfid,
                  name: selectedOption!,
                  date: selectedDate!,
                );

                // Add the new history entry to the database;
                addNewCattleHistory(newHistory);

                // Close the popup dialog
                // fetch
                Navigator.of(context).pop();
              } else {
                // Show an error message if any field is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select an event and date.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                const Color.fromRGBO(13, 166, 186, 0.6),
              ),
            ),
            child: Text(
              currentLocalization['submit']??"",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
