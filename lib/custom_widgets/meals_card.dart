import 'package:calorie_count_app/screens/add_meal_screen.dart';
import 'package:calorie_count_app/screens/edit_meal_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealsCard extends StatefulWidget {
  final Color cardColor;
  final String cardImage;
  final String cardTitle;
  final List<String> cardSubtitle;
  final int cardCalorie;
  final int id;
  final int recommendedCal;
  final DateTime date;
  final Function callbackToUpdateUI;

  const MealsCard(
      {Key key,
      this.cardColor,
      this.cardImage,
      this.cardTitle,
      this.cardSubtitle,
      this.cardCalorie,
      this.id,
      this.recommendedCal,
      this.date,
      this.callbackToUpdateUI})
      : super(key: key);

  @override
  _MealsCardState createState() => _MealsCardState();
}

class _MealsCardState extends State<MealsCard> {
  //to calculate the portion of food such that breakfast:lunch:snack:dinner is 4:3:1:2
  int getFoodPortion() {
    switch (widget.cardTitle.toLowerCase()) {
      case 'breakfast':
        return (widget.recommendedCal / 10 * 4).round();
        break;
      case 'lunch':
        return (widget.recommendedCal / 10 * 3).round();
        break;
      case 'snack':
        return (widget.recommendedCal / 10 * 1).round();
        break;
      case 'dinner':
        return (widget.recommendedCal / 10 * 2).round();
        break;
      default:
        return 0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<String> _foods = widget.cardSubtitle ?? [];

    final Widget foodListView = ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 10),
        itemCount: _foods.length > 3 ? 3 : _foods.length,
        itemBuilder: (BuildContext context, int index) {
          return Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Text(
                  _foods[index],
                  style: TextStyle(fontSize: 16.0),
                ),
              ));
        });

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: widget.cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0))),
        child: InkWell(
          splashColor: widget.cardColor?.withAlpha(30),
          onTap: _foods.isNotEmpty
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditMealScreen(
                            id: widget.id,
                            themeColor: widget.cardColor,
                            mealType: widget.cardTitle,
                            foodList: _foods,
                            calorie: widget.cardCalorie,
                            callbackToUpdateUI: widget.callbackToUpdateUI,
                          )))
              : null,
          child: Container(
            width: size.width / 2.5,
            height: size.height / 2.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: size.height / 7,
                      child: Image.asset(
                        widget.cardImage ?? 'images/lunch.png',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    widget.cardTitle ?? 'Meal',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  _foods.isNotEmpty
                      ? Column(
                          children: <Widget>[
                            Container(
                                height: size.height / 9, child: foodListView),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  widget.cardCalorie?.toString() ?? '0' + ' ',
                                  style: TextStyle(
                                      fontSize: 30.0, color: Colors.white),
                                ),
                                Text('kcal',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white))
                              ],
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Recommended: ',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              getFoodPortion().toString() + ' kcal',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            RawMaterialButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddMealScreen(
                                            themeColor: widget.cardColor,
                                            mealType: widget.cardTitle,
                                            date: widget.date,
                                            callbackToUpdateUI:
                                                widget.callbackToUpdateUI,
                                          ))),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              child: Icon(
                                Icons.add,
                                size: 30.0,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            )
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
