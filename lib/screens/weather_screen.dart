import 'package:flutter/material.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:flutter_project/widgets/drawer.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

/// `WeatherScreen` is a stateful widget that displays the current weather information for a specific city.
///
/// This screen provides a text field for users to input a city name and retrieve its weather details.
/// The fetched data includes temperature, humidity, wind speed, and "feels like" temperature.
///
/// Users can search for the weather of a different city by entering the city's name in the provided text field
/// and tapping the search icon. The results are fetched from the `WeatherApiClient`.
///
/// The widget makes use of the app's theme colors for background, text, and icons. It also utilizes the
/// `FutureBuilder` widget to handle the asynchronous nature of the API call, displaying a loading spinner
/// while the data is being fetched.
///
/// Usage:
/// ```dart
/// WeatherScreen()
/// ```
///
/// Dependencies:
/// - `light_theme.dart`: For the app's light theme colors and styles.
/// - `drawer.dart`: Represents the drawer widget used in this screen.
/// - `weather_model.dart`: Defines the structure of the weather data.
/// - `weather_service.dart`: Contains the API client used for fetching weather data.

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherApiClient client = WeatherApiClient();
  Weather? data;
  String cityName = "Montreal";
  final TextEditingController _controller = TextEditingController();

  Future<void> getData() async {
    data = await client.getCurrentWeather(cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const RedText('Weather Today'),
        centerTitle: true,
      ),
      drawer: TodoDrawer(),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "City name ...",
                        labelStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.8),
                          fontSize: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              cityName = _controller.text.trim();
                              getData();
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            radius: 20,
                            child:
                                const Icon(Icons.search, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      "In ${data!.cityName}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 35,
                          fontWeight: FontWeight.w700),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.cloud,
                          size: 150.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          "${data!.temp} °C",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Humidity",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "${data!.humidity}%",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Wind",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "${data!.wind} km/h",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Feels Like",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "${data!.feelsLike} °C",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
