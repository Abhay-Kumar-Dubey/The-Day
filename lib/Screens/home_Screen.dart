import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:day_counter/Screens/loading_animation.dart';
import 'package:day_counter/appRouter.dart';
import 'package:day_counter/firestore_repository.dart';
import 'package:day_counter/theme/theme_provider.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

String Task = '';
DateTime Deadline = DateTime.now();
var PostDate = FieldValue.serverTimestamp();

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(FirebaseAuthProvider).currentUser;
    final userName = user?.displayName ?? 'User';
    return Scaffold(
        appBar: AppBar(
          title: Text('Hello  $userName'),
          actions: [
            IconButton(
                icon: Icon(Icons.mode_night_sharp),
                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                }),
            IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  context.goNamed(appRoutes.profile.name);
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // double screenHeight = MediaQuery.of(context).size.height;
                // double keyboardHeight =
                //     MediaQuery.of(context).viewInsets.bottom;
                // double availableHeight = screenHeight - keyboardHeight;
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: 650,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 60.0, right: 20, left: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 17.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (Task == '' || Deadline == null) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                'Please fill all the fields'),
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
                                      Future.delayed(
                                          Duration(milliseconds: 100), () {
                                        Navigator.pop(context);
                                        Task = '';
                                      });
                                    }
                                  },
                                  child: Text('Add Task')),
                            ),
                          )
                        ],
                      ),
                    ),
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
    ref
        .read(firestoreRepositoryProvider)
        .addTask(user!.uid, Task, Deadline, PostDate, false, false);
  }
}

class JobsListView extends ConsumerWidget {
  const JobsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirestoreRepository = ref.watch(firestoreRepositoryProvider);
    final user = ref.watch(FirebaseAuthProvider).currentUser;

    return Column(
      children: [
        Expanded(
          child: FirestoreListView(
              query: FirestoreRepository.taskQuery(user!.uid),
              emptyBuilder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please add some Goals To Track',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Lottie.asset('assets/animations/hello.json')
                  ],
                );
              },
              itemBuilder: (BuildContext context,
                  QueryDocumentSnapshot<Map<String, dynamic>> doc) {
                var timestamp = doc['Deadline'];
                var date = timestamp
                    .toDate(); // Converts Firebase Timestamp to DateTime
                String formatted = DateFormat('dd-MM-yyyy').format(date);

                var timestamp2 = doc['taskPostDate'];
                var addedTaskDate = timestamp2
                    .toDate(); // Converts Firebase Timestamp to DateTime
                String initialFormatted =
                    DateFormat('dd-MM-yyyy').format(addedTaskDate);
                int totalDays = date.difference(addedTaskDate).inDays + 2;
                int daysGone = DateTime.now().difference(addedTaskDate).inDays;
                double percentage = (daysGone / totalDays);
                if (percentage >= 1) {
                  percentage = 1.0;
                } else {}
                print(daysGone);
                print(totalDays);
                print(percentage);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: ListTile(
                    title: Text(
                      doc['Heading'],
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(formatted),
                    trailing: Stack(alignment: Alignment.center, children: [
                      SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: percentage,
                            strokeWidth: 7,
                            backgroundColor: Colors.grey.shade100,
                            color: Colors.blueAccent,
                          )),
                      Text(
                        '${(percentage * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),

                    // trailing: RadialProgressAnimation(

                    //   progress: 10,
                    //   color: Colors.blueAccent,
                    // ),
                    onTap: () {
                      print(doc['isDateComplete']);
                      print(doc['isCompleted']);
                      if (!doc['isDateComplete'] == false &&
                          !doc['isCompleted'] == false) {
                        context.push('/HappyScreen');
                      }
                      if (doc['isDateComplete'] && !doc['isCompleted']) {
                        context.push('/ExerciseScreen');
                      }
                      if (doc['isDateComplete'] == false &&
                          doc['isCompleted'] == false) {
                        context.push('/GridDates', extra: [
                          formatted,
                          initialFormatted,
                          doc.id,
                          user.uid
                        ]);
                      }
                    },
                  ),
                );
              }),
        ),
      ],
    );
  }
}
