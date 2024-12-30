import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_counter/appRouter.dart';
import 'package:day_counter/firestore_repository.dart';
import 'package:day_counter/theme/theme_provider.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

var ID = '';
var uid = '';
bool taskEnded = false;

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final arguments = GoRouterState.of(context).extra;
    if (arguments is List<String> && arguments.length >= 2) {
      // Safely parse the dates

      final parsedDate = DateFormat('dd-MM-yyyy').parse(arguments[0]);
      final postDate = DateFormat('dd-MM-yyyy').parse(arguments[1]);
      if (DateTime.now().isBefore(parsedDate) ||
          DateTime.now().isAtSameMomentAs(parsedDate)) {
        ID = arguments[2];
        uid = arguments[3];

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: DateGridView(startDate: postDate, endDate: parsedDate),
        );
      } else {
        ID = arguments[2];
        uid = arguments[3];
        return Scaffold(
          appBar: AppBar(
            title: Text('Days'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0, left: 15),
                  child: Text('Have You Finised Your Task in Mentioned Days? ',
                      style: TextStyle(fontSize: 27)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(uid)
                              .collection('Tasks')
                              .doc(ID)
                              .update({
                            'isDateComplete': true,
                            'isCompleted': true
                          });
                          context.push('/HappyScreen');
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(fontSize: 20),
                        )),
                    TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(uid)
                              .collection('Tasks')
                              .doc(ID)
                              .update({
                            'isDateComplete': true,
                            'isCompleted': false
                          });
                          context.push('/ExerciseScreen');
                        },
                        child: Text('No', style: TextStyle(fontSize: 20))),
                  ],
                )
              ],
            ),
          ),
        );
      }
      ;
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Days"),
        ),
        body: Center(
          child: Text("Invalid arguments"),
        ),
      );
    }
  }
}

// For formatting dates

class DateGridView extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  int x = 1;
  int y = -2;

  DateGridView({required this.startDate, required this.endDate});

  List _generateDateList(DateTime start, DateTime end) {
    List dateList = [];
    DateTime currentDate = start;
    DateTime now = DateTime.now();
    DateTime uploaddate = start;

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      dateList.add(x);
      x++;
      currentDate = currentDate.add(Duration(days: 1));
    }
    while (uploaddate.isBefore(now)) {
      y++;
      uploaddate = uploaddate.add(Duration(days: 1));
    }

    return dateList;
  }

  @override
  Widget build(BuildContext context) {
    final dateList = _generateDateList(startDate, endDate);
    int daysLeft = (dateList.length - y) - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Date Grid View"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_forever_outlined),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Task'),
                        content: Text('Are You Sure About This?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(uid)
                                  .collection('Tasks')
                                  .doc(ID)
                                  .delete();
                              context.pop();
                              Navigator.pop(context);
                            },
                            child: Text('Yes'),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'))
                        ],
                      );
                    });
              })
        ],
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "No. of Days Left :",
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    Text(
                      "$daysLeft",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Days Gone:",
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    Text(
                      "${y + 1}",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns in the grid
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: dateList.length,
              itemBuilder: (context, index) {
                final date = dateList[index];
                Color backgroundcolour;
                if (index <= y) {
                  backgroundcolour = Colors.redAccent.shade400;
                } else {
                  backgroundcolour = Colors.blueAccent;
                }
                return Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: backgroundcolour,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        '$date', // Format the date
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    displayCross(context, index, y)
                  ],
                );
              },
              padding: EdgeInsets.all(8.0),
            ),
          ),
        ],
      ),
    );
  }
}

Widget displayCross(BuildContext context, int index, int y) {
  if (index <= y) {
    return Lottie.asset("assets/animations/Cross.json",
        height: 200, width: 200, repeat: false);
  } else {
    return SizedBox.shrink();
    // return Lottie.asset("assets/animations/Cross.json",
    //     height: 0, width: 0, repeat: false);
  }
}
