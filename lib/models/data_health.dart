//muhammad qodri (2301010172)

class HealthData {
  final String id;
  final String userId;
  final double weight;
  final double height;
  final int age;
  final String gender;
  final List<String> healthConditions;
  final double bmi;

  HealthData({
    required this.id,
    required this.userId,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.healthConditions,
    required this.bmi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'healthConditions': healthConditions,
      'bmi': bmi,
    };
  }

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      id: map['id'],
      userId: map['userId'],
      weight: map['weight'],
      height: map['height'],
      age: map['age'],
      gender: map['gender'],
      healthConditions: List<String>.from(map['healthConditions']),
      bmi: map['bmi'],
    );
  }
}
