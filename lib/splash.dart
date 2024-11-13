import 'package:flutter/material.dart';
import 'package:pixel_parade/features/home_feature/UI/dashboard_widget.dart';
import 'package:pixel_parade/features/purchases/purchaseHelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<StatefulWidget> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
    BillingService.instance.initialize();
  }

  navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardWidget(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          'assets/images/splash_background.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
