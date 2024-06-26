import 'package:flutter/material.dart';
import 'package:meter_reader/Utils/common_widgets/Routes/routes_name.dart';
import 'package:meter_reader/features/Login/presentation/login_view.dart';
import 'package:meter_reader/features/Splash/presentation/splash_view.dart';
import 'package:meter_reader/features/billingRequest/presentation/billing_request_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginView());
      case RoutesName.billingRequest:
        return MaterialPageRoute(
            builder: (BuildContext context) => const BillingRequestPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
