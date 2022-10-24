import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MeteoVille extends StatefulWidget {
  String ville;
  MeteoVille(this.ville);

  @override
  State<MeteoVille> createState() => _MeteoVilleState();
}

class _MeteoVilleState extends State<MeteoVille> {
  var weatherData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(widget.ville);
  }

  getData(String city) {
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=58e2d58251ea448384391ec53a32ae46&units=metric&lang=fr");
    http.get(url).then((res) {
      setState(() {
        weatherData = jsonDecode(res.body);
        print(weatherData);
      });
    }).catchError((err) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Meteo ville de ${widget.ville}"),
          backgroundColor: Colors.deepOrange,
        ),
        body: (weatherData == null
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  decoration: const InputDecoration(
                                      hintText: "saisissez une ville :"),
                                  onChanged: (value) {
                                    setState(() {
                                      widget.ville = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MeteoVille(widget.ville)));
                                      },
                                      child: const Text(
                                        'Voir ...',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      )),
                                ))
                          ],
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 400,
                          height: 300,
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            color: Colors.deepOrange[100],
                            shadowColor: Colors.deepOrange,
                            elevation: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "${weatherData['sys']['country']} ",
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                        Text(
                                          "${weatherData['name']} "
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        "${new DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(weatherData['dt'] * 1000000))}",
                                        style: const TextStyle(
                                            fontSize: 22, color: Colors.black)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${weatherData['main']['temp'].round()} °C",
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.deepOrange[100],
                                    backgroundImage: AssetImage(
                                      'images/${weatherData['weather'][0]['main']}'
                                              .toLowerCase() +
                                          ".png",
                                    ),
                                  ),
                                ),
                                Text(
                                  "${weatherData['weather'][0]['description']} ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )));
  }
}
