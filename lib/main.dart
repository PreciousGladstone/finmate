import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmate/core/utils/service_locator.dart';
import 'package:finmate/core/constants/app_constants.dart';
import 'package:finmate/core/themes/app_theme.dart';
import 'package:finmate/core/router/route.dart';
import 'package:finmate/core/router/routes_map.dart';

void main() {
  // Initialize service locator and dependencies
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.home,
        routes: appRoutes,
        onGenerateRoute: generateRoute,
      ),
    );
  }


}