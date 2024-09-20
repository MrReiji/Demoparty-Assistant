import 'package:demoparty_assistant/utils/navigation/app_router_paths.dart';
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:go_router/go_router.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image covering the entire screen
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/imgs/onboarding-free.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content within a safe area
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: MediaQuery.of(context).size.height * 0.15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Logo and app name section
                  Column(
                    children: [
                      Image.asset("assets/imgs/now-logo.png", scale: 3),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "Demoparty",
                                style: TextStyle(
                                  color: NowUIColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "Assistant",
                                style: TextStyle(
                                  color: NowUIColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Event details section
                  Column(
                    children: [
                      Text(
                        "Łódź, Poland",
                        style: TextStyle(
                          color: NowUIColors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        "29.08.2024 - 01.09.2024",
                        style: TextStyle(
                          color: NowUIColors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  // 'Get Started' button
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: NowUIColors.white, // Text color
                          backgroundColor: NowUIColors.info, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0), // Corners
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
                          ),
                        ),
                        onPressed: () {
                          context.go(AppRouterPaths.home);
                        },
                        child: Text(
                          "GET STARTED",
                          style: TextStyle(fontSize: 15.0).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
