import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final String icon;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });
}

class WeatherProvider with ChangeNotifier {
  Weather? weather;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchWeather(String cityName) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final apiKey = 'YOUR_API_KEY';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName,IN&appid=d26c8913f160f1c4d2bb754f0d55130f&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        weather = Weather(
          cityName: data['name'],
          temperature: data['main']['temp'],
          condition: data['weather'][0]['description'],
          icon: data['weather'][0]['icon'],
          humidity: data['main']['humidity'],
          windSpeed: data['wind']['speed'],
        );
        _saveLastCity(cityName);
      } else {
        errorMessage = 'Error: ${json.decode(response.body)["message"]}';
      }
    } catch (error) {
      errorMessage = 'An error occurred';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshWeather() async {
    if (weather != null) {
      await fetchWeather(weather!.cityName);
    }
  }

  Future<void> _saveLastCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastCity', cityName);
  }

  Future<void> loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('lastCity');
    if (lastCity != null) {
      await fetchWeather(lastCity);
    }
  }
}
