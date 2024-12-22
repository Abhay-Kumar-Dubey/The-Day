import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepository {
  FirestoreRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addTask(String uid, String Heading, DateTime Deadline) async {
    final docRef = await _firestore.collection('Tasks').add({
      'uid': uid,
      'Heading': Heading,
      'Deadline': Deadline,
    });
    debugPrint(docRef.id);
  }

  Query<Map<String, dynamic>> jobsQuery() {
    return _firestore.collection('job');
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});
