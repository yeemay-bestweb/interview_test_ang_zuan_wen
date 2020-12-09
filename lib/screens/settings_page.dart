import 'package:calorie_count_app/constants.dart';
import 'package:calorie_count_app/model/user_model.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double dailyCalNeeds = 0;
  double physicalActivityLevel;

  SharedPreferences sharedPreferences;
  UserPreferences userPreferences;

  Future<UserPreferences> fetchUserPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('gender') &&
        sharedPreferences.containsKey('age') &&
        sharedPreferences.containsKey('weight') &&
        sharedPreferences.containsKey('height') &&
        sharedPreferences.containsKey('lifestyle')) {
      return UserPreferences(
          EnumToString.fromString(
              Gender.values, sharedPreferences.getString('gender')),
          sharedPreferences.getInt('age'),
          sharedPreferences.getInt('weight'),
          sharedPreferences.getDouble('height'),
          EnumToString.fromString(
              Lifestyle.values, sharedPreferences.getString('lifestyle')));
    } else {
      print('user null');
      return UserPreferences(null, 0, 0, 0.0, Lifestyle.lowActive);
    }
  }

  void saveUserPrefs() {
    if (userPreferences.gender != null) {
      sharedPreferences.setString(
          'gender', EnumToString.parse(userPreferences.gender));
    }
    sharedPreferences.setInt('age', userPreferences.age);
    sharedPreferences.setInt('weight', userPreferences.weight);
    sharedPreferences.setDouble('height', userPreferences.height);
    if (userPreferences.lifestyle != null) {
      sharedPreferences.setString(
          'lifestyle', EnumToString.parse(userPreferences.lifestyle));
    }
  }

  Future<void> onEachChange() async {
    //save user preferences into shared preference
    saveUserPrefs();

    //calculate calories
    if (userPreferences.lifestyle != null) {
      switch (userPreferences.gender) {
        case Gender.male:
          switch (userPreferences.lifestyle) {
            case Lifestyle.sedentary:
              setState(() {
                physicalActivityLevel = 1.0;
              });
              break;
            case Lifestyle.lowActive:
              setState(() {
                physicalActivityLevel = 1.12;
              });
              break;
            case Lifestyle.active:
              setState(() {
                physicalActivityLevel = 1.27;
              });
              break;
            case Lifestyle.veryActive:
              setState(() {
                physicalActivityLevel = 1.54;
              });
              break;
          }
          break;
        case Gender.female:
          switch (userPreferences.lifestyle) {
            case Lifestyle.sedentary:
              setState(() {
                physicalActivityLevel = 1.0;
              });
              break;
            case Lifestyle.lowActive:
              setState(() {
                physicalActivityLevel = 1.14;
              });
              break;
            case Lifestyle.active:
              setState(() {
                physicalActivityLevel = 1.27;
              });
              break;
            case Lifestyle.veryActive:
              setState(() {
                physicalActivityLevel = 1.45;
              });
              break;
          }
          break;
        default:
          return null;
          break;
      }
    } else {
      return null;
    }

    if (userPreferences.gender == Gender.male) {
      setState(() {
        dailyCalNeeds = 864 -
            9.72 * userPreferences.age +
            physicalActivityLevel *
                (14.2 * userPreferences.weight + 503 * userPreferences.height);
      });
    } else {
      setState(() {
        dailyCalNeeds = 387 -
            7.31 * userPreferences.age +
            physicalActivityLevel *
                (10.9 * userPreferences.weight +
                    660.7 * userPreferences.height);
      });
    }

    //save totalCal into shared preference
    sharedPreferences.setInt('totalCal', dailyCalNeeds.round());
  }

  @override
  void initState() {
    fetchUserPrefs().then((user) {
      setState(() {
        this.userPreferences = user;
        print(userPreferences.lifestyle.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'SETTINGS',
                    style: kHintTextStyle.copyWith(
                        fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Container(
                          height: 100.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Gender',
                            style: kLabelStyle.copyWith(fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton.icon(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: Image.asset(
                                  'images/male.png',
                                  height: 35.0,
                                  width: 35.0,
                                  color: userPreferences?.gender == Gender.male
                                      ? const Color(0xFF6fa1ea)
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    userPreferences.gender = Gender.male;
                                  });
                                  onEachChange();
                                },
                                label: Text(
                                  'Male',
                                ),
                              ),
                              FlatButton.icon(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: Image.asset(
                                  'images/female.png',
                                  height: 35.0,
                                  width: 35.0,
                                  color:
                                      userPreferences?.gender == Gender.female
                                          ? const Color(0xFFf5bad3)
                                          : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    userPreferences.gender = Gender.female;
                                  });
                                  onEachChange();
                                },
                                label: Text('Female'),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Container(
                          height: 100.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'Age',
                                style: kLabelStyle.copyWith(fontSize: 16),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  userPreferences?.age.toString() ?? '0',
                                  style: kLabelStyle.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            onChanged: (double value) {
                              setState(() {
                                userPreferences.age = value.round();
                              });
                            },
                            value: userPreferences != null
                                ? userPreferences.age.toDouble()
                                : 0.0,
                            min: 0.0,
                            max: 100.0,
                            divisions: 100,
                            onChangeEnd: (double value) {
                              onEachChange();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Container(
                          height: 100.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'Weight (kg)',
                                style: kLabelStyle.copyWith(fontSize: 16),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  userPreferences?.weight.toString() ?? null,
                                  style: kLabelStyle.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            onChanged: (double value) {
                              setState(() {
                                userPreferences.weight = value.round();
                              });
                            },
                            value: userPreferences != null
                                ? userPreferences.weight.toDouble()
                                : 0.0,
                            min: 0.0,
                            max: 200.0,
                            divisions: 200,
                            onChangeEnd: (double value) {
                              onEachChange();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Container(
                          height: 100.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'Height(m)',
                                style: kLabelStyle.copyWith(fontSize: 16),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  userPreferences?.height.toString() ?? null,
                                  style: kLabelStyle.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            onChanged: (double value) {
                              setState(() {
                                userPreferences.height =
                                    double.parse(value.toStringAsFixed(2));
                              });
                            },
                            value: userPreferences != null
                                ? userPreferences.height.toDouble()
                                : 0.0,
                            min: 0.0,
                            max: 2.5,
                            divisions: 250,
                            onChangeEnd: (double value) {
                              onEachChange();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Container(
                          height: 280.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Lifestyle',
                            style: kLabelStyle.copyWith(fontSize: 16),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: userPreferences?.lifestyle != null
                                ? CustomRadioButton(
                                    defaultSelected:
                                        userPreferences?.lifestyle ?? null,
                                    horizontal: true,
                                    enableShape: true,
                                    elevation: 0,
                                    absoluteZeroSpacing: false,
                                    unSelectedColor:
                                        Theme.of(context).canvasColor,
                                    buttonLables: [
                                      'Sedentary',
                                      'Average',
                                      'Active',
                                      'Very Active'
                                    ],
                                    buttonValues: [
                                      Lifestyle.sedentary,
                                      Lifestyle.lowActive,
                                      Lifestyle.active,
                                      Lifestyle.veryActive,
                                    ],
                                    buttonTextStyle: ButtonTextStyle(
                                        selectedColor: Colors.white,
                                        unSelectedColor: Colors.black,
                                        textStyle: TextStyle(fontSize: 16)),
                                    radioButtonValue: (value) {
                                      setState(() {
                                        userPreferences.lifestyle = value;
                                      });
                                      onEachChange();
                                    },
                                    selectedColor:
                                        Theme.of(context).accentColor,
                                  )
                                : null,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('Recommended Intake Per Day (kcal): ' +
                            dailyCalNeeds.round().toString()),
                      )
                    ],
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
