//muhammad qodri (2301010172)

import 'package:flutter/material.dart';
import 'package:klp_mobile3/models/data_health.dart';
import 'package:klp_mobile3/models/workout_recomendation.dart';
import 'package:klp_mobile3/screens/detail_workout_screen.dart';
import 'package:klp_mobile3/screens/login_screen.dart';
import 'package:klp_mobile3/services/service_health.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:klp_mobile3/services/service_workout_recomendation.dart';
import 'health_screen.dart';

class WorkoutRecommendationsScreen extends StatefulWidget {
  final String? userEmail;

  const WorkoutRecommendationsScreen({
    super.key,
    this.userEmail,
  });

  @override
  _WorkoutRecommendationsScreenState createState() =>
      _WorkoutRecommendationsScreenState();
}

class _WorkoutRecommendationsScreenState
    extends State<WorkoutRecommendationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final HealthService _healthService;
  late final WorkoutService _workoutService;
  List<WorkoutRecommendation>? _recommendations;

  //setting warna yang nantinya dipanggil
  final Color primaryColor = const Color(0xFF3A6EA5);
  final Color accentColor = const Color(0xFF004E98);
  final Color backgroundColor = const Color(0xFF15202B);
  final Color cardColor = const Color(0xFF1C2732);
  final Color danger = const Color(0xFFE63946);
  final Color primaryBlue = const Color(0xFF48CAE4);
  final Color darkBlue = const Color(0xFF2C405E);

  @override
  void initState() {
    super.initState();
    _healthService = HealthService(userEmail: widget.userEmail);
    _workoutService = WorkoutService(userEmail: widget.userEmail ?? '');
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _loadRecommendations();
  }

  //fungsi memuat data rekomendasi workout
  Future<void> _loadRecommendations() async {
    try {
      final healthData = await _healthService.getHealthData('current_user_id');
      final recommendations =
          await _workoutService.getRecommendations(healthData);
      setState(() {
        _recommendations = recommendations;
      });
    } catch (e) {
      print('Error loading recommendations: $e');
    }
  }

  //merubah durasi workout
  Future<void> _updateWorkoutDuration(String workoutId, int newDuration) async {
    await _workoutService.updateWorkoutDuration(workoutId, newDuration);
    await _loadRecommendations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: accentColor,
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder<HealthData>(
            future: _healthService.getHealthData('current_user_id'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                );
              }

              if (snapshot.hasError) {
                return _buildErrorWidget();
              }

              return _buildMainContent(snapshot.data!);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(Icons.edit, color: primaryBlue),
        onPressed: () async {
          final healthData =
              await _healthService.getHealthData('current_user_id');
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HealthFormScreen(
                isEditing: true,
                initialData: healthData,
              ),
            ),
          );
          if (result == true) {
            await _loadRecommendations();
          }
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: danger.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: cardColor,
                title: Text('Logout', style: TextStyle(color: primaryBlue)),
                content: Text('Are you sure you want to logout?',
                    style: TextStyle(color: primaryBlue)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: primaryBlue),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: danger,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text('Logout', style: TextStyle(color: primaryBlue)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: primaryBlue,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error loading rekomendasi',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() {});
            },
            child: const Text('Retry', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(HealthData healthData) {
    if (_recommendations == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          backgroundColor: backgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            title: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.only(bottom: 16),
                height: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Workout Plan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    if (widget.userEmail != null)
                      Text(
                        widget.userEmail!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/workout1.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          backgroundColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [_buildEditButton(), _buildLogoutButton()],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildHealthSummaryCard(context, healthData),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Rekomendasi Workout',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildWorkoutCard(_recommendations![index]),
                    ),
                  ),
                );
              },
              childCount: _recommendations!.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthSummaryCard(BuildContext context, HealthData healthData) {
    String bmiCategory = _getBMICategory(healthData.bmi);
    Color categoryColor = _getBMICategoryColor(healthData.bmi);

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBlue.withOpacity(0.8), backgroundColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Kesehatan Anda',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildHealthInfoRow(
                'BMI',
                '${healthData.bmi.toStringAsFixed(1)}',
                subtitle: bmiCategory,
                color: categoryColor,
              ),
              _buildHealthInfoRow('Berat', '${healthData.weight} kg'),
              _buildHealthInfoRow('Tinggi', '${healthData.height} cm'),
              _buildHealthInfoRow('Umur', '${healthData.age}'),
              _buildHealthInfoRow('Jenis Kelamin', healthData.gender),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthInfoRow(String label, String value,
      {String? subtitle, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color ?? Colors.white,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: color ?? Colors.white70,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutRecommendation recommendation) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailScreen(
              workout: recommendation,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardColor,
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    recommendation.gifUrl,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              recommendation.title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            _buildDurationEditor(recommendation),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recommendation.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Mulai',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationEditor(WorkoutRecommendation recommendation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: primaryBlue, size: 20),
            onPressed: () {
              setState(() {
                if (recommendation.durationInSeconds >
                    WorkoutRecommendation.minDurationInSeconds) {
                  recommendation.durationInSeconds -=
                      WorkoutRecommendation.defaultIncrement;
                }
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
          GestureDetector(
            onTap: () => _showDurationPicker(recommendation),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                recommendation.formattedDuration,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: primaryBlue, size: 20),
            onPressed: () {
              setState(() {
                if (recommendation.durationInSeconds <
                    WorkoutRecommendation.maxDurationInSeconds) {
                  recommendation.durationInSeconds +=
                      WorkoutRecommendation.defaultIncrement;
                }
              });
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ],
      ),
    );
  }

  void _showDurationPicker(WorkoutRecommendation recommendation) {
    int minutes = recommendation.durationInSeconds ~/ 60;
    int seconds = recommendation.durationInSeconds % 60;

    final TextEditingController minutesController = TextEditingController(
      text: minutes.toString(),
    );
    final TextEditingController secondsController = TextEditingController(
      text: seconds.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        title: const Text('Atur Durasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minutesController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      suffix: const Text('menit'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: secondsController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      suffix: const Text('detik'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: recommendation.durationInSeconds.toDouble(),
              min: WorkoutRecommendation.minDurationInSeconds.toDouble(),
              max: WorkoutRecommendation.maxDurationInSeconds.toDouble(),
              divisions: (WorkoutRecommendation.maxDurationInSeconds -
                      WorkoutRecommendation.minDurationInSeconds) ~/
                  WorkoutRecommendation.defaultIncrement,
              label: recommendation.formattedDuration,
              activeColor: primaryBlue,
              onChanged: (value) {
                setState(() {
                  recommendation.durationInSeconds = value.round();
                  minutesController.text = (value.round() ~/ 60).toString();
                  secondsController.text = (value.round() % 60).toString();
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: primaryBlue),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
            ),
            onPressed: () {
              int? newMinutes = int.tryParse(minutesController.text);
              int? newSeconds = int.tryParse(secondsController.text);

              if (newMinutes != null && newSeconds != null) {
                int totalSeconds = (newMinutes * 60) + newSeconds;
                if (totalSeconds >=
                        WorkoutRecommendation.minDurationInSeconds &&
                    totalSeconds <=
                        WorkoutRecommendation.maxDurationInSeconds) {
                  setState(() {
                    recommendation.durationInSeconds = totalSeconds;
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Durasi total harus antara 10 detik - 60 menit'),
                      backgroundColor: danger,
                    ),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Kurus';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Gemuk';
    return 'Obesitas';
  }

  Color _getBMICategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.pink;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return const Color.fromARGB(255, 195, 255, 0);
    return Colors.red;
  }
}
