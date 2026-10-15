//muhammad qodri (2301010172)

import 'package:klp_mobile3/models/data_health.dart';
import 'package:klp_mobile3/models/workout_recomendation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class WorkoutService {
  final String userEmail;
  final _uuid = const Uuid();
  static const String _storageKey = 'workout_recommendations';

  WorkoutService({required this.userEmail});

  // Mendapatkan rekomendasi berdasarkan BMI
  Future<List<WorkoutRecommendation>> getRecommendations(
      HealthData healthData) async {
    await clearRecommendations();
    List<WorkoutRecommendation> recommendations =
        _generateRecommendations(healthData);
    await _saveRecommendations(recommendations);
    return recommendations;
  }

  List<WorkoutRecommendation> _generateRecommendations(HealthData healthData) {
    List<WorkoutRecommendation> recommendations = [];

    if (healthData.bmi < 18.5) {
      recommendations.addAll(_getUnderweightRecommendations());
    } else if (healthData.bmi >= 18.5 && healthData.bmi < 25) {
      recommendations.addAll(_getNormalWeightRecommendations());
    } else if (healthData.bmi >= 25 && healthData.bmi < 30) {
      recommendations.addAll(_getOverweightRecommendations());
    } else {
      recommendations.addAll(_getObeseRecommendations());
    }

    return recommendations;
  }

  // Method untuk menyimpan rekomendasi
  Future<void> _saveRecommendations(
      List<WorkoutRecommendation> recommendations) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(
      recommendations.map((r) => r.toJson()).toList(),
    );
    await prefs.setString('${_storageKey}_$userEmail', data);
  }

  //method untuk membersihkan cache
  Future<void> clearRecommendations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_storageKey}_$userEmail');
  }

  // Method untuk mengambil rekomendasi tersimpan
  Future<List<WorkoutRecommendation>> _getSavedRecommendations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('${_storageKey}_$userEmail');

    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList
          .map((json) => WorkoutRecommendation.fromJson(json))
          .toList();
    }
    return [];
  }

  // Method untuk update duration
  Future<void> updateWorkoutDuration(String workoutId, int newDuration) async {
    List<WorkoutRecommendation> recommendations =
        await _getSavedRecommendations();

    final index = recommendations.indexWhere((r) => r.id == workoutId);
    if (index != -1) {
      recommendations[index].updateDuration(newDuration);
      await _saveRecommendations(recommendations);
    }
  }

  // methods untuk generate rekomendasi berdasarkan kategori
  List<WorkoutRecommendation> _getUnderweightRecommendations() {
    return [
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Push-ups',
        description:
            'Bangun kekuatan tubuh bagian atas dengan bentuk push-up yang tepat',
        gifUrl: 'assets/gifs/pushup1.png',
        durationInSeconds: 45,
        userEmail: userEmail,
      ),
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Squat jump',
        description: 'Memperkuat tubuh bagian bawah dan membangun massa otot',
        gifUrl: 'assets/gifs/squat3.png',
        durationInSeconds: 60,
        userEmail: userEmail,
      ),
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Berenang',
        description: 'Latihan seluruh tubuh berdampak rendah',
        gifUrl: 'assets/gifs/swimming1.png',
        durationInSeconds: 30,
        userEmail: userEmail,
      ),
    ];
  }

  List<WorkoutRecommendation> _getNormalWeightRecommendations() {
    return [
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Olahraga HIIT',
        description:
            'Latihan interval intensitas tinggi untuk kebugaran secara keseluruhan',
        gifUrl: 'assets/gifs/hiit2.png',
        durationInSeconds: 90,
        userEmail: userEmail,
      ),
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Angkat Beban',
        description: 'Rutinitas latihan dengan kekuatan seimbang',
        gifUrl: 'assets/gifs/angkatbbn.png',
        durationInSeconds: 50,
        userEmail: userEmail,
      ),
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Olahraga Cardio',
        description: 'Campuran dari lari, bersepeda dll',
        gifUrl: 'assets/gifs/cardio.png',
        durationInSeconds: 145,
        userEmail: userEmail,
      ),
    ];
  }

  List<WorkoutRecommendation> _getOverweightRecommendations() {
    return [
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Jongkok',
        description:
            'Membantu menurunkan berat badan dengan olahraga jongkok yang tepat',
        gifUrl: 'assets/gifs/squat1.png',
        durationInSeconds: 45,
        userEmail: userEmail,
      ),
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'jogging',
        description: 'Memperkuat tubuh bagian bawah dan membangun massa otot',
        gifUrl: 'assets/gifs/jogging.png',
        durationInSeconds: 85,
        userEmail: userEmail,
      ),
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Diet Makanan Berprotein',
        description:
            'Sertakan telur, daging tanpa lemak, dan kacang-kacangan saat makan',
        gifUrl: 'assets/gifs/nutrition2.png',
        durationInSeconds: 60,
        userEmail: userEmail,
      ),
    ];
  }

  List<WorkoutRecommendation> _getObeseRecommendations() {
    return [
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Jalan Cepat',
        description: 'Mulailah dengan berjalan kaki 30 menit setiap hari',
        gifUrl: 'assets/gifs/walking2.png',
        durationInSeconds: 35,
        userEmail: userEmail,
      ),
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Diet Makanan Berprotein',
        description:
            'Sertakan telur, daging tanpa lemak, dan kacang-kacangan saat makan',
        gifUrl: 'assets/gifs/nutrition2.png',
        durationInSeconds: 30,
        userEmail: userEmail,
      ),
      WorkoutRecommendation(
        id: _uuid.v4(),
        title: 'Yoga',
        description: 'Meningkatkan fleksibilitas dan kekuatan inti',
        gifUrl: 'assets/gifs/yoga1.png',
        durationInSeconds: 120,
        userEmail: userEmail,
      ),
    ];
  }
}
