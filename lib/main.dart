import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:mi_sueldo/pages/home.dart';
import 'package:mi_sueldo/pages/starting.dart';
import 'package:mi_sueldo/pages/config.dart';
import 'package:mi_sueldo/pages/month.dart';

import 'package:mi_sueldo/services/Salary.dart';
import 'package:mi_sueldo/services/dailySalary.dart';
import 'package:mi_sueldo/services/myTymer.dart';

// import 'package:mi_sueldo/services/dailySalary.g.dart';

// void main() => runApp(MaterialApp(
// theme: ThemeData(),
// initialRoute: '/',
// routes: {
//   '/': (context) => Starting(),
//   '/home': (context) => Home(),
//   '/config': (context) => Config(),
//   '/month': (context) => Month(),
// },
//     ));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(DailySalaryAdapter());
  Hive.registerAdapter(SalaryAdapter());
  Hive.registerAdapter(MyTimerAdapter());
  // await Hive.openBox('DailySalary');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      // initialRoute: '/',
      routes: {
        // '/': (context) => Starting(),
        '/home': (context) => Home(),
        '/config': (context) => Config(),
        '/month': (context) => Month(),
      },
      home: FutureBuilder(
        future: Hive.openBox('Salary'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return Home();
          }
          // Although opening a Box takes a very short time,
          // we still need to return something before the Future completes.
          else
            return Starting();
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
