import 'package:flutter/material.dart';

class AppResources {
  static const String appName = "DevArt";
  static const String appTagline = "Authentic Handcrafted Artisan Creations";

  static const Color primaryColor = Color(0xFF704522);
  static const Color secondaryColor = Color(0xFFA06D42);
  static const Color backgroundColor = Color(0xFFFAF7F5);

  static const Color appBarBackgroundColor = Color(0xFFBFD5FA);

  static const Color bottomNavBackgroundColor = Color(0xFFC4D9FF);
  static const Color bottomNavBorderColor = Color(0xFF8DAEEA);

  static const Color headerBannerColor = Color(0xFFF5E9E5);
  static const Color headerBgColor = Color(0xFFF5E9E5);

  static const Color headerTextColor = Color(0xFFB56F6F);

  static const Color cardBackgroundColor = Color(0xFFD9D9D9);
  static const Color cardLightColor = Color(0xFFE2E2E2);

  static const Color textPrimaryColor = Colors.black;
  static const Color textSecondaryColor = Color(0xFF5F5550);
  static const Color textMutedColor = Color(0xFF8B7B72);

  static const String logo = "lib/assets/images/devart-logo.png";
  static const String appLogo = "lib/assets/images/devart-logo.png";

  static const String authBackgroundImage =
      "lib/assets/images/devart_bgimage_auth.png";
  static const String bgImageAuth = "lib/assets/images/devart_bgimage_auth.png";

  static const String homeBackgroundImage =
      "lib/assets/images/devart_bgimg_home.png";
  static const String bgImageHome = "lib/assets/images/devart_bgimg_home.png";

  static const String dashboardBackgroundImage =
      "lib/assets/images/devart_bgimg_dashboard.png";
  static const String bgImageDashboard =
      "lib/assets/images/devart_bgimg_dashboard.png";

  static const String adminBackgroundImage =
      "lib/assets/images/devart_bgimg_admin.png";
  static const String bgImageAdmin = "lib/assets/images/devart_bgimg_admin.png";

  static const String homeBanner = "lib/assets/images/devart_new_arrival.webp";
  static const String bannerNewArrival =
      "lib/assets/images/devart_new_arrival.webp";

  static const String defaultProductImage =
      "lib/assets/images/devart_product_1.webp";
  static const String placeholderProduct =
      "lib/assets/images/devart_product_1.webp";

  static const String defaultCategoryImage =
      "lib/assets/images/devart_product_1.webp";

  static const TextStyle pageTitleStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: headerTextColor,
    fontFamily: "serif",
  );

  static const TextStyle priceStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle oldPriceStyle = TextStyle(
    fontSize: 10,
    color: Colors.red,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppResources.primaryColor,
      primary: AppResources.primaryColor,
      secondary: AppResources.secondaryColor,
      surface: AppResources.backgroundColor,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: AppResources.backgroundColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppResources.appBarBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppResources.textPrimaryColor,
      ),
      iconTheme: IconThemeData(color: Colors.black, size: 28),
    ),

    cardTheme: CardThemeData(
      color: AppResources.cardBackgroundColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(
        color: AppResources.textMutedColor,
        fontSize: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppResources.primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppResources.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: AppResources.buttonTextStyle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppResources.primaryColor,
        side: const BorderSide(color: AppResources.primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppResources.bottomNavBackgroundColor,
      selectedItemColor: AppResources.textPrimaryColor,
      unselectedItemColor: Colors.black54,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
