import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather_provider.dart';

class DummyWeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data
    String cityName = "San Francisco";
    double temperature = 22.0;
    String condition = "Sunny";
    String iconUrl = "http://openweathermap.org/img/w/01d.png";
    int humidity = 60;
    double windSpeed = 5.0;
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.weather!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                provider.weather!.cityName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${provider.weather!.temperature}°C',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                provider.weather!.condition,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Image.network('http://openweathermap.org/img/w/${provider.weather!.icon}.png', scale: 0.5),
              SizedBox(height: 16),
              Text(
                'Humidity: ${provider.weather!.humidity}%',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'Wind Speed: ${provider.weather!.windSpeed} m/s',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .refreshWeather();
                },
                style: ElevatedButton.styleFrom(

                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Refresh'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
