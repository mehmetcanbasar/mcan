import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCAN',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  int _timerHours = 0;
  int _timerMinutes = 0;
  int _timerSeconds = 3;
  bool _timerActive = false;
  String _demleButtonText = 'DEMLE';
  var _demlenmestatus = 0;
  bool _timershow = false;
  Color _background = Color.fromARGB(255, 255, 255, 255);
  String _demlendiTarihSaat = '';
  String _secondGifUrl = 'https://cdn.radar.istanbul/699edf41-c497-4577-8eeb-74773da93f73.gif';
  bool _secondGifVisible = false;

  Color _BackgroundColor() {
    if (_demlenmestatus == 0) {
      return Color.fromARGB(255, 131, 161, 126);
    } else if (_demlenmestatus == 1) {
      return Color.fromARGB(255, 142, 187, 134);
    } else if (_demlenmestatus == 2) {
      return Color.fromARGB(255, 82, 146, 71);
    } else if (_demlenmestatus == 3) {
      return Color.fromARGB(255, 24, 1, 1);
    } else {
      return Color.fromARGB(255, 28, 247, 76);
    }
  }

  void _BayatUyari() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tekrar Demle"),
          content: Text("Tekrar demlemek istediğine emin misin?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _timerHours = 0;
                _timerMinutes = 0;
                _timerSeconds = 3;
                _timerActive = true;
                _demlenmestatus = 1;
                _timershow = true;
                _demleButtonText = 'DEMLENİYOR';
                _startTimer();
              },
              child: Text("Evet"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Hayır"),
            ),
          ],
        );
      },
    );
  }

  void _updateButton(Timer timer) {
    setState(() {
      if (_timerHours == 0 &&
          _timerMinutes == 0 &&
          _timerSeconds == 0 &&
          _demlenmestatus == 1) {
        _demlenmestatus = 2;
        _timer.cancel();
        _timerActive = false;
        _timerHours = 0;
        _timerMinutes = 0;
        _timerSeconds = 3;
        _timershow = true;
        _demleButtonText = 'TAZE';
        _background = Color.fromARGB(255, 255, 255, 255);
        _demlendiTarihSaat = _getFormattedDateTime();
        _timer = Timer.periodic(const Duration(seconds: 1), _updateButton);
        _secondGifVisible = true;
      } else if (_demlenmestatus == 2 &&
          _timerHours == 0 &&
          _timerMinutes == 0 &&
          _timerSeconds == 0) {
        _demleButtonText = 'BAYAT';
        _background = Color.fromARGB(255, 255, 255, 255);
        _demlenmestatus = 3;
        _secondGifVisible = false;
      }

      if (_demlenmestatus == 3 &&
          _timerHours == 0 &&
          _timerMinutes == 0 &&
          _timerSeconds == 0) {
        _timershow = false;
      }

      if (_timerHours > 0 || _timerMinutes > 0 || _timerSeconds > 0) {
        if (_timerSeconds == 0) {
          if (_timerMinutes > 0) {
            _timerMinutes--;
            _timerSeconds = 59;
          } else {
            if (_timerHours > 0) {
              _timerHours--;
              _timerMinutes = 59;
              _timerSeconds = 59;
            }
          }
        } else {
          _timerSeconds--;
        }
      }
    });
  }

  String _getFormattedDateTime() {
    DateTime now = DateTime.now();
    return '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}';
  }

  void _startTimer() {
    if (_timerActive) {
      _timer.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), _updateButton);
    _timerActive = true;
    _timershow = true;
    _demleButtonText = 'DEMLENİYOR';
    _background = Color.fromARGB(255, 255, 255, 255);
    _demlenmestatus = 1;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double topPercentage = -5;
    double leftPercentage = 14;

    double topPosition = (topPercentage / 100) * screenHeight;
    double leftPosition = (leftPercentage / 100) * screenWidth;

    const double spaceBetweenGifAndButton = 50;

    return Scaffold(
      backgroundColor: _BackgroundColor(),
      appBar: AppBar(
        backgroundColor: _BackgroundColor(),
        actions: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.01),
            child: Image.network(
              'https://cdn.radar.istanbul/0c916e63-b765-4186-b41e-680b371328cd.gif',
              fit: BoxFit.cover,
            ),
          ),
        ],
        title: Text(widget.title),
        toolbarHeight: screenHeight * 0.11,
      ),
      body: Stack(
        children: [
          Positioned(
            top: topPosition,
            left: leftPosition,
            child: Visibility(
              visible: _timerActive && _demlenmestatus == 1,
              child: CachedNetworkImage(
                imageUrl: 'https://cdn.radar.istanbul/0c916e63-b765-4186-b41e-680b371328cd.gif',
                width: screenWidth * 0.66,
                height: screenHeight * 0.5,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: 130,
            child: Visibility(
              visible: _secondGifVisible,
              child: CachedNetworkImage(
                imageUrl: _secondGifUrl,
                width: screenWidth * 0.37,
                height: screenHeight * 0.27,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: topPosition + screenHeight * 0.15 + spaceBetweenGifAndButton),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.13,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (!_timerActive &&
                            _demlenmestatus != 3 &&
                            _demlenmestatus != 2) {
                          _startTimer();
                        }

                        if (_demlenmestatus == 3) {
                          _BayatUyari();
                        }
                      },
                      backgroundColor: _background,
                      tooltip: 'Increment',
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _demleButtonText,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 24,
                              shadows: [
                                Shadow(
                                  blurRadius: 200.0,
                                  color: Colors.black,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),

                  _timershow
                      ? Column(
                          children: [
                            Text(
                              'Kalan Süre: ${_timerHours.toString().padLeft(2, '0')}: ${_timerMinutes.toString().padLeft(2, '0')}:${_timerSeconds.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        )
                      : Container(),

                  const SizedBox(height: 60),
                  if ((_demlenmestatus == 2 || _demlenmestatus == 3) &&
                      _demlendiTarihSaat.isNotEmpty)
                    Text(
                      'Son Demleme: $_demlendiTarihSaat',
                      style: TextStyle(
                          fontSize: 18,
                          color: _demlenmestatus == 2
                              ? Colors.white
                              : Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() { 
     
    _timer.cancel();
    super.dispose();
}
}