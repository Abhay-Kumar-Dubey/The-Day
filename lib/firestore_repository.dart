import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_counter/Screens/Goal_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late String TaskID;

class FirestoreRepository {
  FirestoreRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addTask(String uid, String Heading, DateTime Deadline,
      FieldValue taskPostDate, bool isCompleted, bool isDateComplete) async {
    final docRef =
        await _firestore.collection('Users').doc(uid).collection('Tasks').add({
      'uid': uid,
      'Heading': Heading,
      'Deadline': Deadline,
      'taskPostDate': taskPostDate,
      'isCompleted': isCompleted,
      'isDateComplete': isDateComplete
    });
    TaskID = docRef.id;
    debugPrint(docRef.id);
  }

  Query<Map<String, dynamic>> taskQuery(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('Tasks')
        .orderBy('taskPostDate');
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});
