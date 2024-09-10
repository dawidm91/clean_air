import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'main.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key, this.weather}) : super(key: key);

  final Weather? weather;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Color(0xffffffff),
              gradient: getGradientByMood(widget.weather)),
        ),
        Align(
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 45.0)),
                Image(
                    image: AssetImage(
                        'icons/${getIconByMood(widget.weather)}.png')),
                const Padding(
                  padding: EdgeInsets.only(top: 41.0),
                ),
                Text(
                  "${DateFormat.MMMMEEEEd('pl').format(DateTime.now())}, ${widget.weather?.weatherDescription ?? 'Brak danych'}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 14.0,
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                ),
                Text(
                  '${widget.weather?.temperature?.celsius?.floor().toString() ?? '--'}°C',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 64.0,
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
                Text(
                  'Odczuwalna ${widget.weather?.tempFeelsLike?.celsius?.floor().toString() ?? '--'}°C',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 14.0,
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
                Padding(padding: EdgeInsets.only(top: 24.0)),
                IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Ciśnienie",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 14.0,
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300)),
                              ),
                              Padding(padding: EdgeInsets.only(top: 2.0)),
                              Text(
                                "${widget.weather?.pressure?.toString() ?? '--'} hPa",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 26.0,
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          width: 48,
                          color: Colors.white,
                          thickness: 1,
                        ),
                        Container(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Wiatr",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontSize: 14.0,
                                          height: 1.2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300))),
                              Padding(padding: EdgeInsets.only(top: 2.0)),
                              Text(
                                "${widget.weather?.windSpeed?.toString() ?? '--'} km/h",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 26.0,
                                        height: 1.2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Padding(padding: EdgeInsets.only(top: 24.0)),
                Text(
                  "Opady ${widget.weather?.rainLastHour?.toString() ?? 'Brak danych'} mm/12h",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 14.0,
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                ),
                Padding(padding: EdgeInsets.only(top: 68.0)),
              ],
            )),
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String getIconByMood(Weather? weather) {
    var main = weather?.weatherMain;
    if (main == 'Clouds' || main == 'Drizzle' || main == 'Snow') {
      return 'weather-rain';
    } else if (main == 'Thunderstorm') {
      return 'weather-lightning';
    } else if (isNight(weather)) {
      return 'weather-moonny';
    } else {
      return 'weather-sunny';
    }
  }

  bool isNight(Weather? weather) {
    if (weather == null || weather.sunset == null || weather.sunrise == null) return false;
    final now = DateTime.now();
    return now.isAfter(weather.sunset!) || now.isBefore(weather.sunrise!);
  }

  LinearGradient getGradientByMood(Weather? weather) {
    var main = weather?.weatherMain;
    if (main == 'Clouds' || main == 'Drizzle' || main == 'Snow') {
      return LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xff6E6CD8), Color(0xff40A0EF), Color(0xff77E1EE)]);
    } else if (main == 'Thunderstorm' || isNight(weather)) {
      return LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xff313545), Color(0xff21118)]);
    } else {
      return LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [Color(0xff5283F0), Color(0xffCDEDD4)]);
    }
  }
}