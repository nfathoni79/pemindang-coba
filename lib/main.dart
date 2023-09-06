import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/views/login_view.dart';
import 'package:pemindang_coba/views/main_view.dart';
import 'package:pemindang_coba/views/pending_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  setupLocator();

  Widget home = const MainView();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('accessToken') == null) {
    home = const LoginView();
  }

  if (prefs.getBool('pendingApproval') != null) {
    home = const PendingView();
  }

  runApp(MyApp(home: home));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.home,
  });

  final Widget home;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perindo Bisnis',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
