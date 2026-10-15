//muhammad qodri (2301010172)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klp_mobile3/models/data_health.dart';

class HealthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userEmail;

  HealthService({this.userEmail});

  Future<void> createHealthData(HealthData healthData) async {
    await _firestore
        .collection('health_data')
        .doc(healthData.id)
        .set(healthData.toMap());
  }

  Future<HealthData> getHealthData(String userId) async {
    final doc = await _firestore
        .collection('health_data')
        .where('userId', isEqualTo: userId)
        .get();
    return HealthData.fromMap(doc.docs.first.data());
  }

  Future<void> updateHealthData(HealthData healthData) async {
    await _firestore
        .collection('health_data')
        .doc(healthData.id)
        .update(healthData.toMap());
  }

  Future<void> deleteHealthData(String id) async {
    await _firestore.collection('health_data').doc(id).delete();
  }
}
