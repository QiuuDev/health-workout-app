class WorkoutRecommendation {
  final String id;
  final String title;
  final String description;
  final String gifUrl;
  int durationInSeconds;
  final String userEmail;
  static const int minDurationInSeconds = 10; //minimum 10 detik
  static const int maxDurationInSeconds = 3600; // Maksimum 60 menit
  static const int defaultIncrement = 30; // Increment 30 detik

  WorkoutRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.gifUrl,
    required this.durationInSeconds,
    required this.userEmail,
  });

  // getter untuk format waktu mm:ss
  String get formattedDuration {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Method JSON tetap sama tapi menggunakan nama baru
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'gifUrl': gifUrl,
      'durationInSeconds': durationInSeconds,
      'userEmail': userEmail,
    };
  }

  factory WorkoutRecommendation.fromJson(Map<String, dynamic> json) {
    return WorkoutRecommendation(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      gifUrl: json['gifUrl'],
      durationInSeconds: json['durationInSeconds'],
      userEmail: json['userEmail'],
    );
  }

  void updateDuration(int newDurationInSeconds) {
    if (newDurationInSeconds >= minDurationInSeconds &&
        newDurationInSeconds <= maxDurationInSeconds) {
      durationInSeconds = newDurationInSeconds;
    }
  }
}
