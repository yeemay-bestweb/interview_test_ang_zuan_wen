import 'dart:convert';

import 'package:calorie_count_app/model/meal_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiCaller {
  static const BASEURL = 'https://bestweb.my/interview_test/';
  static const APIKEY = 'interviewtest@8888';
  static const Map<String, String> API_DEFAULT_REQUEST_HEADERS = {
    "Content-Type": "application/x-www-form-urlencoded",
  };

  ///TODO: Create your api caller functions here

  // Create API function

  static Future<Meal> getFunction() async {
    debugPrint("Execute getFunction");
    Dio dio = new Dio();

    var response = await dio.get(BASEURL,
        options: Options(headers: API_DEFAULT_REQUEST_HEADERS));

    final jsonMeal = jsonDecode(response.data);

    return Meal.fromJson(jsonMeal);
  }

  static Future<Meal> postFunction(variable) async {
    debugPrint("Execute postFunction");
    Dio dio = new Dio();

    var response = await dio.post(BASEURL,
        options: Options(headers: API_DEFAULT_REQUEST_HEADERS),
        data: {'param': variable});

    var data = json.decode(response.data);
    return data;
  }

// Below are sample functions to make GET and POST API calls, you can
  // write your own function too :)
  //
  // static Future getFunction() async {
  //   var response = http.get(<api_url>, headers: <headers>);
  //   var data = var data = jsonDecode(response.body);
  //   return data;
  // }
  //
  // static Future postFunction(variable) async {
  //   var response = await http.post(<api_url>,
  //       headers: <headers>,
  //       body: {
  //         'param': variable,
  //       });
  //   var data = json.decode(response.body);
  //   return data;
  // }

}
