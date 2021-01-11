import 'package:flutter/material.dart';

class WeatherData {
  String cityName;
  String degrees;
  String desc;
  String feelsLike;
  String wind;
  String humidity;

  WeatherData(
      {this.cityName,
      this.degrees,
      this.desc,
      this.feelsLike,
      this.wind,
      this.humidity});
}
