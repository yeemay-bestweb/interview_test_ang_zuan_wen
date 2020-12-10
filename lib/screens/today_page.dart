import 'package:calorie_count_app/custom_widgets/meals_card.dart';
import 'package:calorie_count_app/model/meal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayPage extends StatefulWidget {
  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<Meal> mealsList = [];
  int totalCal = 0;
  int recommendedCal = 0;
  DateTime dateNow;
  String dateString;

  ///hint: you may need this to handle API calls
  ///bool loading = true;

  loadList() {
    ///TODO: Call Get Meal API here
  }

  @override
  void initState() {
    dateNow = DateTime.now();
    dateString = DateFormat('dd-MM-yyyy').format(dateNow);
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('totalCal')) {
      recommendedCal = sharedPreferences.getInt('totalCal');
    }
    await loadList();
    super.didChangeDependencies();
  }

  ///TODO: use this callback function to update TodayPage UI after edit or add meals
  callbackToUpdateUI(List<Meal> meal, int cal) {
    setState(() {
      mealsList = meal;
      totalCal = cal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
        child: Container(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: AppBar(
                backgroundColor: Colors.blue[800],
                title: Text('My Calorie Records'),
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                height: size.height / 2,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      List<Color> colors = [
                        Colors.amber,
                        Colors.indigoAccent.shade200,
                        Colors.pink,
                        Colors.teal
                      ];
                      List<String> images = [
                        'images/breakfast.png',
                        'images/lunch.png',
                        'images/snack.png',
                        'images/dinner.png',
                      ];
                      List<String> mealType = [
                        'Breakfast',
                        'Lunch',
                        'Snack',
                        'Dinner'
                      ];
                      return mealsList.isNotEmpty
                          ? MealsCard(
                              cardColor: colors[index],
                              cardImage: images[index],
                              cardTitle: mealType[index],
                              cardSubtitle: index < mealsList.length
                                  ? [
                                      mealsList[index].foodName,
                                      mealsList[index].food2Name,
                                      mealsList[index].food3Name
                                    ]
                                  : [],
                              cardCalorie: index < mealsList.length
                                  ? mealsList[index].calorie
                                  : 0,
                              id: index < mealsList.length
                                  ? mealsList[index].id
                                  : index + 1,
                              recommendedCal: recommendedCal ?? 0,
                              date: dateNow,
                              callbackToUpdateUI: callbackToUpdateUI,
                            )
                          : MealsCard(
                              cardColor: colors[index],
                              cardImage: images[index],
                              cardTitle: mealType[index],
                              cardSubtitle: [],
                              cardCalorie: 0,
                              id: index + 1,
                              recommendedCal: recommendedCal ?? 0,
                              date: dateNow,
                              callbackToUpdateUI: callbackToUpdateUI,
                            );
                    })
                // ListView(
                //   scrollDirection: Axis.horizontal,
                //   children: <Widget>[
                //     MealsCard(cardColor: Colors.amber, cardImage: ,)
                //     getMealsCardByName('breakfast', Colors.amber),
                //     getMealsCardByName('lunch', Colors.indigoAccent.shade200),
                //     getMealsCardByName('snack', Colors.pink),
                //     getMealsCardByName('dinner', Colors.teal),
                //   ],
                // )
                ),
            CircularPercentIndicator(
              radius: size.height / 4.5,
              lineWidth: 13.0,
              animation: true,
              percent: (totalCal / recommendedCal).toDouble() > 1.0
                  ? 1.0
                  : (totalCal / recommendedCal).toDouble(),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (totalCal.toDouble() / recommendedCal * 100).isInfinite ||
                            (totalCal.toDouble() / recommendedCal * 100).isNaN
                        ? '0%'
                        : (totalCal.toDouble() / recommendedCal * 100)
                                .toStringAsFixed(0) +
                            "%",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  Text(
                    'Recommended: \n$recommendedCal kcal',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              footer: Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: Text(
                  'Total Intake On This Day: ' + totalCal.toString() + ' kcal',
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.cyan[700],
            ),
          ],
        ),
      ),
    ));
  }
}
