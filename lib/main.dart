import 'package:flutter/material.dart';

import 'package:movies_app/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:movies_app/providers/movies_provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoviesProvider(),lazy: false,)  
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      initialRoute: 'home',
      routes: {
        'home':    (_) => const HomeScreen(),
        'details': (_) => const DetailsScreen()
      },
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
        backgroundColor: Colors.red.shade700
        )
      ),
      
    );
  }
}