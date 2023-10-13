import 'dart:convert';
import '../config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApiClient {
  String apiKey = API_KEY;

  Future<Weather>? getCurrentWeather(String? location) async {
    var endpoint = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric");

    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);

    debugPrint(Weather.fromJson(body).cityName);

    return Weather.fromJson(body);
  }
}
