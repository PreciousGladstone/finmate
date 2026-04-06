import 'package:finmate/core/themes/app_color.dart';
import 'package:finmate/core/themes/app_textstyle.dart';
import 'package:flutter/material.dart';

/// Application theme configuration using AppColors and AppTextStyles
class AppTheme {
  /// Light theme for the application
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryDefault,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDefault,
        secondary: AppColors.secondary01Default,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.secondary01Light,
        onSecondaryContainer: AppColors.secondary01Default,
        tertiary: AppColors.secondary02Default,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.secondary02Light,
        onTertiaryContainer: AppColors.secondary02Default,
        error: AppColors.errorDefault,
        onError: AppColors.white,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.errorDefault,
        background: AppColors.backgroundLight,
        onBackground: AppColors.textColor,
        surface: AppColors.white,
        onSurface: AppColors.textColor,
        surfaceVariant: AppColors.grey100,
        onSurfaceVariant: AppColors.grey700,
        outline: AppColors.grey300,
        outlineVariant: AppColors.grey200,
        scrim: AppColors.black,
      ),
      
      /// Text Theme Configuration
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        headlineLarge: AppTextStyles.h3Bold,
        headlineMedium: AppTextStyles.h4,
        headlineSmall: AppTextStyles.h5,
        titleLarge: AppTextStyles.h6,
        titleMedium: AppTextStyles.p1Medium,
        titleSmall: AppTextStyles.p1,
        bodyLarge: AppTextStyles.p1,
        bodyMedium: AppTextStyles.p2,
        bodySmall: AppTextStyles.p2Light,
        labelLarge: AppTextStyles.p1Medium,
        labelMedium: AppTextStyles.p2Bold,
        labelSmall: AppTextStyles.caption,
      ),

      /// AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textColor,
        titleTextStyle: AppTextStyles.h5Bold,
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),

      /// Input Decoration Theme (TextField, etc.)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryDefault, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorDefault, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorDefault, width: 2),
        ),
        labelStyle: AppTextStyles.p1.copyWith(color: AppColors.grey700),
        hintStyle: AppTextStyles.p2Light.copyWith(color: AppColors.hintColor),
        helperStyle: AppTextStyles.caption.copyWith(color: AppColors.grey600),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.errorDefault),
        prefixStyle: AppTextStyles.p2.copyWith(color: AppColors.textColor),
        suffixStyle: AppTextStyles.p2.copyWith(color: AppColors.textColor),
        counterStyle: AppTextStyles.caption.copyWith(color: AppColors.grey500),
      ),

      /// Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDefault,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.p1Medium,
          elevation: 0,
        ).copyWith(
          overlayColor: MaterialStateProperty.all(
            AppColors.primaryDefault.withOpacity(0.1),
          ),
        ),
      ),

      /// Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDefault,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.p1Medium,
        ).copyWith(
          overlayColor: MaterialStateProperty.all(
            AppColors.primaryDefault.withOpacity(0.1),
          ),
        ),
      ),

      /// Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDefault,
          side: const BorderSide(color: AppColors.primaryDefault, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.p1Medium,
        ).copyWith(
          overlayColor: MaterialStateProperty.all(
            AppColors.primaryDefault.withOpacity(0.1),
          ),
        ),
      ),

      /// Filled Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.secondary02Default,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.p1Medium,
        ).copyWith(
          overlayColor: MaterialStateProperty.all(
            AppColors.secondary02Default.withOpacity(0.1),
          ),
        ),
      ),

      /// Card Theme
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.grey200, width: 1),
        ),
        margin: const EdgeInsets.all(0),
      ),

      /// Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: AppTextStyles.h5Bold.copyWith(color: AppColors.textColor),
        contentTextStyle: AppTextStyles.p1.copyWith(color: AppColors.textColor2),
      ),

      /// Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryLight,
        selectedColor: AppColors.primaryDefault,
        disabledColor: AppColors.grey300,
        labelStyle: AppTextStyles.p2.copyWith(color: AppColors.textColor),
        secondaryLabelStyle:
            AppTextStyles.p2.copyWith(color: AppColors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),

      /// Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryDefault,
        unselectedItemColor: AppColors.grey500,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      /// Navigation Bar Theme (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: AppColors.primaryLight,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(
              color: AppColors.primaryDefault,
              size: 28,
            );
          }
          return const IconThemeData(
            color: AppColors.grey500,
            size: 26,
          );
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTextStyles.p2Bold.copyWith(
              color: AppColors.primaryDefault,
            );
          }
          return AppTextStyles.p2.copyWith(
            color: AppColors.grey500,
          );
        }),
      ),

      /// FAB Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryDefault,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      /// Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryDefault;
          }
          return AppColors.grey300;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.grey400, width: 1.5),
      ),

      /// Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryDefault;
          }
          return AppColors.grey400;
        }),
      ),

      /// Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryDefault;
          }
          return AppColors.grey400;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryDefault.withOpacity(0.5);
          }
          return AppColors.grey300;
        }),
      ),

      /// Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.grey200,
        thickness: 1,
        space: 16,
      ),

      /// Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey900,
        contentTextStyle:
            AppTextStyles.p1.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 8,
      ),

      /// List Tile Theme
      listTileTheme: ListTileThemeData(
        titleTextStyle: AppTextStyles.p1.copyWith(color: AppColors.textColor),
        subtitleTextStyle:
            AppTextStyles.p2.copyWith(color: AppColors.grey600),
        selectedTileColor: AppColors.primaryLight,
        selectedColor: AppColors.primaryDefault,
      ),

      /// Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryDefault,
        circularTrackColor: AppColors.grey200,
        linearTrackColor: AppColors.grey200,
      ),

      /// Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textColor,
        size: 24,
      ),

      /// Scaffold Background Color
      scaffoldBackgroundColor: AppColors.backgroundLight,

      /// Page Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
