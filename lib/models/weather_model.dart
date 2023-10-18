/// `Weather` represents the weather data for a particular city.
///
/// This class holds information about the city's name, temperature, wind speed, humidity, and the 'feels like' temperature.
///
/// Attributes:
/// - `cityName`: The name of the city.
/// - `temp`: The current temperature in the city (in Celsius).
/// - `wind`: The current wind speed in the city (in meters per second).
/// - `humidity`: The current humidity level in the city (in percentage).
/// - `feelsLike`: The 'feels like' temperature (in Celsius).
///
/// Constructor:
/// - Default constructor allows for the instantiation of a `Weather` object with initial values.
/// - `fromJson` constructor allows for the instantiation of a `Weather` object from a JSON map, typically fetched from a weather API.
///
/// Example:
/// ```dart
/// Weather weather = Weather(cityName: "London", temp: 20.5);
///
/// Map<String, dynamic> jsonWeatherData = fetchWeatherDataFromAPI();
/// Weather weatherFromJson = Weather.fromJson(jsonWeatherData);
/// ```

class Weather {
  String? cityName;
  double? temp;
  double? wind;
  int? humidity;
  double? feelsLike;

  Weather({this.cityName, this.temp, this.wind, this.humidity, this.feelsLike});

  Weather.fromJson(Map<String, dynamic> json) {
    cityName = json["name"];
    temp = (json["main"]["temp"] as num).toDouble().roundToDouble();
    wind = json["wind"]["speed"];
    humidity = json["main"]["humidity"];
    feelsLike = (json["main"]["feels_like"] as num).toDouble().roundToDouble();
  }
}
