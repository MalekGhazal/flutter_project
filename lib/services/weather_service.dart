import 'dart:convert';
import '../config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

/// `WeatherApiClient` is a service class responsible for fetching current weather data from the OpenWeatherMap API.
///
/// It uses the provided API key (`API_KEY`) from the `config.dart` file to authenticate the requests. The API returns weather data in metric units.
///
/// Key Functionalities:
/// 1. Fetch current weather for a specific city (`location`) with `getCurrentWeather`.
///
/// Dependencies:
/// - `http.dart`: For making HTTP requests.
/// - `dart:convert`: For decoding the JSON response.
/// - `config.dart`: Contains the API key for OpenWeatherMap.
/// - `weather_model.dart`: Data model to map and handle the API's response.
///
/// Example:
/// ```dart
/// WeatherApiClient apiClient = WeatherApiClient();
/// Weather? weather = await apiClient.getCurrentWeather("London");
/// print(weather?.cityName);  // This will print the name of the city if the request was successful.
/// ```
///
/// The `getCurrentWeather` function prints the name of the city to the debug console using `debugPrint` after fetching the weather data.

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
