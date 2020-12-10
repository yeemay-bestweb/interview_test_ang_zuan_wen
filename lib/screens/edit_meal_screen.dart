import 'package:calorie_count_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditMealScreen extends StatefulWidget {
  final int id;
  final Color themeColor;
  final String mealType;
  final List<String> foodList;
  final int calorie;
  final Function callbackToUpdateUI;

  const EditMealScreen(
      {Key key,
      this.themeColor,
      this.mealType,
      this.foodList,
      this.calorie,
      this.id,
      this.callbackToUpdateUI})
      : super(key: key);
  @override
  _EditMealScreenState createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _editMealKey = GlobalKey<FormState>();
  final _food1Controller = TextEditingController();
  final _food2Controller = TextEditingController();
  final _food3Controller = TextEditingController();
  final _calorieController = TextEditingController();

  @override
  void initState() {
    List<TextEditingController> _foodControllers = [
      _food1Controller,
      _food2Controller,
      _food3Controller
    ];

    for (int i = 0; i < widget.foodList.length; i++) {
      _foodControllers[i].text = widget.foodList[i];
    }

    _calorieController.text = widget.calorie.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.themeColor,
        title: Text('Edit ' + widget.mealType),
      ),
      body: Form(
        key: _editMealKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Foods You\'ve Taken',
                  style: kLabelStyle,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    controller: _food1Controller,
                    decoration: InputDecoration(
                      labelText: "Enter Food 1 (*required)",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Food 1 cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    style: kHintTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    controller: _food2Controller,
                    decoration: InputDecoration(
                      labelText: "Enter Food 2",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.text,
                    style: kHintTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    controller: _food3Controller,
                    decoration: InputDecoration(
                      labelText: "Enter Food 3",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    keyboardType: TextInputType.text,
                    style: kHintTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Total Calories Estimated',
                    style: kLabelStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    controller: _calorieController,
                    decoration: InputDecoration(
                      labelText: "Enter Estimated Calories",
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (value) {
                      Pattern pattern = '^[0-9]*\$';
                      RegExp regex = new RegExp(pattern);

                      if (!regex.hasMatch(value)) {
                        return 'Only numbers allowed (without \'.\', \'-\' or any other symbols)';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    style: kHintTextStyle,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  elevation: 5.0,
                  onPressed: () {
                    String type;
                    switch (widget.mealType) {
                      case 'Breakfast':
                        type = '1';
                        break;
                      case 'Lunch':
                        type = '2';
                        break;
                      case 'Snack':
                        type = '3';
                        break;
                      case 'Dinner':
                        type = '4';
                        break;
                    }
                    print('Type ; $type');
                    FocusScope.of(context).unfocus();
                    if (_editMealKey.currentState.validate()) {
                      _editMealKey.currentState.save();
                      if ((_food2Controller.text.isEmpty ||
                              _food2Controller.text == '' ||
                              _food2Controller.text == null) &&
                          _food3Controller.text.isNotEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please don\'t skip fields.',
                            backgroundColor: Colors.black);
                      }

                      ///TODO: Call Edit Meal API here and show a success/fail toast
                      ///Hint: Remember to use callback function to update TodayPage UI too,
                      ///Or you can use your preferred State Management method (eg: Provider)
                    }
                  },
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: widget.themeColor,
                  child: Container(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'EDIT ' + widget.mealType.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
