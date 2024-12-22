import 'package:date_field/date_field.dart';
import 'package:day_counter/appRouter.dart';
import 'package:day_counter/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String Task = '';
DateTime Deadline = DateTime.now();

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
                            FirestoreAdd(ref);
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
      body: Center(
        child: Text('Welcome to Home Screen'),
      ),
    );
  }

  void FirestoreAdd(WidgetRef ref) {
    final user = ref.read(FirebaseAuthProvider).currentUser;
    ref.read(firestoreRepositoryProvider).addTask(
          user!.uid,
          Task,
          Deadline,
        );
  }
}
