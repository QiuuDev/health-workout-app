//muhammad qodri (2301010172)

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:klp_mobile3/models/workout_recomendation.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutRecommendation workout;

  const WorkoutDetailScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  Timer? _timer;
  late int _timeLeft;
  bool _isRunning = false;

  final Color primaryColor = const Color(0xFF48CAE4);
  final Color backgroundColor = const Color(0xFF15202B);
  final Color cardColor = const Color(0xFF1C2732);
  final Color textColor = const Color(0xFFE0E6ED);
  final Color accentColor = const Color(0xFF3A6EA5);

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.workout.durationInSeconds;
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_timeLeft > 0) {
          setState(() {
            _timeLeft--;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _timeLeft = widget.workout.durationInSeconds; // Reset timer
          });
          _showCompletionDialog();
        }
      },
    );
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _timeLeft = widget.workout.durationInSeconds;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: Text(
            'Workout Selesai!',
            style: TextStyle(color: primaryColor),
          ),
          content: const Text(
            'Selamat! Anda telah menyelesaikan sesi workout ini.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text('Ulangi', style: TextStyle(color: primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
                _resetTimer();
              },
            ),
            TextButton(
              child: Text('Selesai', style: TextStyle(color: primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDurationInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            'Durasi Latihan: ${widget.workout.durationInSeconds} detik',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: cardColor,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.workout.title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.8),
                      cardColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.workout.gifUrl,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Timer Display with enhanced design
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _formatTime(_timeLeft),
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildControlButton(
                          icon: Icons.refresh,
                          onPressed: _resetTimer,
                          isMain: false,
                        ),
                        const SizedBox(width: 24),
                        _buildControlButton(
                          icon: _isRunning ? Icons.pause : Icons.play_arrow,
                          onPressed: _isRunning ? _pauseTimer : _startTimer,
                          isMain: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Description with enhanced styling
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instruksi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.workout.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isMain,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isMain ? primaryColor : cardColor,
          foregroundColor: isMain ? cardColor : primaryColor,
          padding: const EdgeInsets.all(20),
          shape: const CircleBorder(),
          elevation: isMain ? 8 : 4,
        ),
        onPressed: onPressed,
        child: Icon(
          icon,
          size: 32,
          color: isMain ? textColor : primaryColor,
        ),
      ),
    );
  }
}
