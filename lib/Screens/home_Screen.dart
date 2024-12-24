import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:day_counter/appRouter.dart';
import 'package:day_counter/firestore_repository.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

String Task = '';
DateTime Deadline = DateTime.now();
var PostDate = FieldValue.serverTimestamp();

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
          actions: [
            IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  context.goNamed(appRoutes.profile.name);
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Write Your Task here',
                        ),
                        onChanged: (value) {
                          Task = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: DateTimeFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Task Deadline',
                          ),
                          firstDate: DateTime.now(),
                          initialPickerDateTime:
                              DateTime.now().add(const Duration(days: 20)),
                          mode: DateTimeFieldPickerMode.date,
                          onChanged: (DateTime? value) {
                            Deadline = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: ElevatedButton(
                            onPressed: () {
                              if (Task == '' || Deadline == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content:
                                          Text('Please fill all the fields'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                FirestoreAdd(ref);
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Add Task')),
                      )
                    ],
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
        body: JobsListView());
  }

  void FirestoreAdd(WidgetRef ref) {
    final user = ref.read(FirebaseAuthProvider).currentUser;
    ref.read(firestoreRepositoryProvider).addTask(
          user!.uid,
          Task,
          Deadline,
          PostDate,
        );
  }
}

class JobsListView extends ConsumerWidget {
  const JobsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirestoreRepository = ref.watch(firestoreRepositoryProvider);
    final user = ref.watch(FirebaseAuthProvider).currentUser;
    return FirestoreListView(
        query: FirestoreRepository.taskQuery(user!.uid),
        itemBuilder: (BuildContext context,
            QueryDocumentSnapshot<Map<String, dynamic>> doc) {
          var timestamp = doc['Deadline'];
          var date =
              timestamp.toDate(); // Converts Firebase Timestamp to DateTime
          String formatted = DateFormat('dd-MM-yyyy').format(date);
          var timestamp2 = doc['taskPostDate'];
          var addedTaskDate =
              timestamp2.toDate(); // Converts Firebase Timestamp to DateTime
          String initialFormatted =
              DateFormat('dd-MM-yyyy').format(addedTaskDate);

          return ListTile(
            title: Text(doc['Heading']),
            subtitle: Text(formatted),
            onTap: () {
              context.push('/GridDates',
                  extra: [formatted, initialFormatted, doc.id]);
              // Navigator.pushNamed(context, appRoutes.GridDates.name,
              //     arguments: [doc.id, formatted]);
            },
          );
        });
  }
}
