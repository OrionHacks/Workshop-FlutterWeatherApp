import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:weather_app/services/apis.dart';
import 'package:weather_app/widgets/weatherTile.dart';
import 'package:weather_app/models/weatherData.dart';
import 'package:date_format/date_format.dart';
import 'package:loading/loading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position _currentPosition;
  Widget status;
  List<String> cities;
  WeatherData _weatherData;
  bool loaded = false;

  void _setup() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position pos;
    WeatherData data;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    setState(() {
      loaded = false;
    });

    pos = await Geolocator.getCurrentPosition();
    data = await _getWeather(
        "Cupertino", pos.latitude.toString(), pos.longitude.toString());

    setState(() {
      _currentPosition = pos;
      _weatherData = data;
      loaded = true;
    });
  }

  Future<WeatherData> _getWeather(
      String cityName, String lat, String long) async {
    Map<dynamic, dynamic> json = await APIS().getWeatherData(lat, long);
    double degs = (json["current"]["temp"] - 273.15) * 9 / 5 + 32;
    double fl = (json["current"]["feels_like"] - 273.15) * 9 / 5 + 32;

    WeatherData _weatherData = WeatherData(
        cityName: cityName,
        degrees: degs.round().toString(),
        desc: json["current"]["weather"][0]["main"],
        feelsLike: fl.round().toString(),
        wind: json["current"]["wind_speed"].toString(),
        humidity: json["current"]["humidity"].toString());

    return _weatherData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    String date = formatDate(
            DateTime(now.year, now.month, now.day), [M, ' ', dd, ', ', yyyy])
        .toString();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/cloudy_night.jpg'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.dstATop)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.search_outlined,
                  color: Colors.white,
                  size: 25,
                ),
                SizedBox(
                  height: 20,
                ),
                info(loaded, date),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget info(bool isLoaded, String date) {
    return !isLoaded
        ? Center(
            child: Loading(
              indicator: BallPulseIndicator(),
              color: Colors.white,
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _weatherData.cityName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                date,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),
              Text(_weatherData.degrees + " ℉",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 70)),
              SizedBox(
                height: 5,
              ),
              Text(_weatherData.desc,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 16)),
              SizedBox(
                height: 10,
              ),
              Divider(color: Colors.white),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  weatherTile("Feels Like", _weatherData.feelsLike, "℉"),
                  weatherTile("Wind", _weatherData.wind, "km/h"),
                  weatherTile("Humidity", _weatherData.humidity, "%")
                ],
              ),
            ],
          );
  }
}
