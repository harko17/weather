import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather_screen.dart';
import 'weather_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .fetchWeather(_cityController.text);
                  if(!WeatherProvider().isLoading && WeatherProvider().errorMessage.isEmpty)
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DummyWeatherScreen()));

                  });
                },
                child: Text('Get Weather'),
              ),
              SizedBox(height: 16),
              Consumer<WeatherProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return CircularProgressIndicator();
                  } else if (provider.weather != null ) {
                    return WeatherDetails();
                  }
                  if (provider.errorMessage.isNotEmpty) {
                    return Text(provider.errorMessage);
                  } else {
                    return Text('Enter a city to get the weather');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.weather!;

    return Column(
      children: [
        if (provider.errorMessage.isNotEmpty)
          Text(provider.errorMessage,style: TextStyle(color: Colors.red),),
        SizedBox(height: 16),
        Text('City: ${provider.weather!.cityName}'),
        Text('Temperature: ${provider.weather!.temperature}°C'),
        Text('Condition: ${provider.weather!.condition}'),
        Image.network('http://openweathermap.org/img/w/${provider.weather!.icon}.png'),
        Text('Humidity: ${provider.weather!.humidity}%'),
        Text('Wind Speed: ${provider.weather!.windSpeed} m/s'),
        if (provider.errorMessage.isNotEmpty)
          Text(provider.errorMessage),

        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Provider.of<WeatherProvider>(context, listen: false)
                .refreshWeather();
          },
          child: Text('Refresh'),
        ),
      ],
    );
  }
}
