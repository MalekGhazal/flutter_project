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
