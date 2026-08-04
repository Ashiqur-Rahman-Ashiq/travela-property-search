import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/helper/route_healper.dart';
import 'package:flutter_clean_boilerplate/utill/app_constants.dart';
import 'package:flutter_clean_boilerplate/utill/custom_themes.dart';
import 'package:flutter_clean_boilerplate/utill/dimensions.dart';
import 'package:flutter_clean_boilerplate/utill/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _redirectTimer = Timer(const Duration(seconds: 5), _redirect);
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  Future<void> _redirect() async {
    if (!mounted) return;
    RouterHelper.getHomeRoute(action: RouteAction.pushNamedAndRemoveUntil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(Images.logoWithNameImage, width: 150),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(AppConstants.appName, style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeOverLarge)),
          ],
        ),
      ),
    );
  }
}
