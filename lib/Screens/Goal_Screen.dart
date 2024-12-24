import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_counter/appRouter.dart';
import 'package:day_counter/firestore_repository.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

var ID = '';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arguments = GoRouterState.of(context).extra;
    if (arguments is List<String> && arguments.length >= 2) {
      // Safely parse the dates

      final parsedDate = DateFormat('dd-MM-yyyy').parse(arguments[0]);
      final postDate = DateFormat('dd-MM-yyyy').parse(arguments[1]);
      ID = arguments[2];

      return MaterialApp(
        home: DateGridView(startDate: postDate, endDate: parsedDate),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Goal Screen"),
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
      print(y);
      uploaddate = uploaddate.add(Duration(days: 1));
    }

    return dateList;
  }

  @override
  Widget build(BuildContext context) {
    final dateList = _generateDateList(startDate, endDate);

    return Scaffold(
      appBar: AppBar(
        title: Text("Date Grid View"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_forever_outlined),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(ID)
                    .collection('Tasks')
                    .doc('$ID')
                    .delete();
                context.pop();
              })
        ],
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: GridView.builder(
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
            backgroundcolour = Colors.redAccent;
          } else {
            backgroundcolour = Colors.blueAccent;
          }
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundcolour,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              '$date', // Format the date
              style: TextStyle(color: Colors.white),
            ),
          );
        },
        padding: EdgeInsets.all(8.0),
      ),
    );
  }
}
