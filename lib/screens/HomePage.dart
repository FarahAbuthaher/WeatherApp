import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_app_task/main.dart';
import 'package:login_app_task/screens/weatherAPI.dart';
import 'package:login_app_task/services/signIn/SignIn_bloc.dart';
import 'EditInfo.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  SigninBloc? signinBloc;

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather in Amman'), actions: [
        Tooltip(
          message: 'Edit profile',
          child: IconButton(
            onPressed: () => Navigator.pushNamed(context, EditInfo.routeName),
            icon: Icon(Icons.settings_applications),
          ),
        ),
        Tooltip(
          message: 'Logout',
          child: IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout),
          ),
        )
      ]),
      body: FutureBuilder(
        future: getWeatherData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text('${snapshot.error} has occurred.'),
            );
          else if (snapshot.hasData) {
            final WeatherData weather = snapshot.data as WeatherData;
            return Center(
              child: Container(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter,colors: [Colors.deepOrange[500]!,Colors.orange[900]!,Colors.orange,Colors.orange[400]!])),
                width: MediaQuery.of(context).size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        size: 80, color: Colors.deepOrange,
                      ),
                      Text(
                        'Welcome, ${weather.name} - ${weather.sys.country}!',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        color: Colors.yellow[400],
                        width: 300,
                        height: 300,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              height: 250,
                              child: Card(
                                color: Colors.yellow[400],
                                elevation: 60,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Icon(Icons.thermostat_rounded),
                                        Text('${weather.main.temp} F / ${weather.weather.first.main}',
                                            style: TextStyle(fontSize: 20))
                                      ]),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      Row(children: [
                                        Icon(Icons.beach_access_sharp, color: Colors.green),
                                        Text(
                                            'Feels like: ${weather.main.feelsLike} F',
                                            style: TextStyle(fontSize: 15))
                                      ]),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.whatshot, color: Colors.orange,),
                                          Text(
                                              'Range: ${weather.main.tempMin} F',
                                              style: TextStyle(fontSize: 15)),
                                          Icon(Icons.arrow_right),
                                          Text('${weather.main.tempMax} F')
                                        ],
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.water_rounded, color: Colors.blue,),
                                          Text(
                                              'Humidity: ${weather.main.humidity} F',
                                              style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text('wind - speed: ${weather.wind.speed}, blow direction from north: ${weather.wind.deg} degrees', style: TextStyle(fontSize: 12, color: Colors.black38),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
