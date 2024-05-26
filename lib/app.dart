import 'package:crud_practice_using_rest_api/view/homepage.dart';
import 'package:flutter/material.dart';

class CRUD extends StatelessWidget {
  const CRUD({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD Practice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(double.maxFinite),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white),
        ),
      ),
      home: const MyHomePage(title: 'Product List'),
    );
  }
}
