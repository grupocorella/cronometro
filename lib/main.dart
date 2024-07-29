import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mike Corella',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: TemorizadorDemo(
        isDarkMode: _isDarkMode,
        onThemeChanged: (bool isDarkMode) {
          setState(() {
            _isDarkMode = isDarkMode;
          });
        },
      ),
    );
  }
}

class TemorizadorDemo extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const TemorizadorDemo({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<TemorizadorDemo> createState() => _TemorizadorDemoState();
}

class _TemorizadorDemoState extends State<TemorizadorDemo> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  String _result = '00:00:00';
  final List<String> _partialTimes = [];
  bool _isRunning = false; 

  void _toggleTimer() {
    if (_isRunning) {
      _stop();
    } else {
      _start();
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        _result =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      });
    });

    _stopwatch.start();
    setState(() {
      _isRunning = true;
    });
  }

  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _reset() {
    _stop();
    _stopwatch.reset();
    setState(() {
       _result =
            '00:00:00';
      _partialTimes.clear();
    });
  }

  void _recordPartial() {
    if (_isRunning) {
      setState(() {
        _partialTimes.add(_result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desarrollo App IEU'),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.amber,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.network(
                  'https://static.capabiliaserver.com/frontend/clients/barca/wp_prod/wp-content/uploads/2019/11/77804c9e-logo-1-ieu.png', // Reemplaza con la URL de tu imagen
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tiempo:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    _result,
                    style: const TextStyle(
                      fontSize: 50.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _toggleTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRunning ? Colors.amber : Colors.black87,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(_isRunning ? 'Detener' : 'Iniciar'),
                      ),
                      ElevatedButton(
                        onPressed: _reset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reiniciar'),
                      ),
                      ElevatedButton(
                        onPressed: _recordPartial,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Parcial'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  Expanded(
                    child: ListView.builder(
                      itemCount: _partialTimes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Parcial ${index + 1}: ${_partialTimes[index]}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Autor: Mike Corella',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
