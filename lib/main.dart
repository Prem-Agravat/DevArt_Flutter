import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devart/firebase_options.dart';
import 'package:devart/resource/resource.dart';
import 'package:devart/services/address_service.dart';
import 'package:devart/services/auth_service.dart';
import 'package:devart/services/cart_service.dart';
import 'package:devart/services/wishlist_service.dart';
import 'package:devart/user_panel/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService.instance.init();
  runApp(const DevArtApp());
}

class DevArtApp extends StatelessWidget {
  const DevArtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthService.instance),
        ChangeNotifierProvider.value(value: CartService.instance),
        ChangeNotifierProvider.value(value: WishlistService.instance),
        ChangeNotifierProvider.value(value: AddressService.instance),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppResources.appName,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
