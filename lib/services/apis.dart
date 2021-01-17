import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIS {
  Future<Map<dynamic, dynamic>> getWeatherData(String lat, String long) async {
    String apiKey = "c5e06a3001f70b0df68c3203d15c680f";
    String url =
        "https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${long}&exclude=hourly,daily&appid=${apiKey}";
    var jsonResponse;

    var response = await http.get(url);

    if (response.statusCode == 200) {
      jsonResponse = jsonDecode(response.body);
    } else {
      print("Unsuccessful");
    }

    return jsonResponse;
  }
}
