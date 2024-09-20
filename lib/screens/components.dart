import 'package:flutter/material.dart';
import 'package:demoparty_assistant/constants/Theme.dart';

// widgets
import 'package:demoparty_assistant/utils/widgets/navbar.dart';
import 'package:demoparty_assistant/utils/widgets/drawer.dart';
import 'package:demoparty_assistant/utils/widgets/input.dart';
import 'package:demoparty_assistant/utils/widgets/table-cell.dart';

class Components extends StatefulWidget {
  @override
  _ComponentsState createState() => _ComponentsState();
}

class _ComponentsState extends State<Components> {
  bool? switchValueOne;
  bool? switchValueTwo;

  void initState() {
    setState(() {
      switchValueOne = true;
      switchValueTwo = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: "Components",
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      drawer: NowDrawer(currentPage: "Components"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 16, left: 16, bottom: 36),
          child: SafeArea(
            bottom: true,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 32, bottom: 32),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Buttons",
                        style: TextStyle(
                            color: NowUIColors.text,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Respond to button press
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          NowUIColors.defaultColor, // Button text color
                      backgroundColor:
                          NowUIColors.white, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(4.0), // Rounded corners
                      ),
                      padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 12,
                          bottom: 12), // Button padding
                    ),
                    child: Text("DEFAULT", style: TextStyle(fontSize: 14.0)),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: NowUIColors.white, // Text color
                        backgroundColor:
                            NowUIColors.primary, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 12,
                          bottom: 12,
                        ),
                      ),
                      onPressed: () {
                        // Respond to button press
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text("PRIMARY", style: TextStyle(fontSize: 14.0)),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: NowUIColors.white, // Text color
                        backgroundColor:
                            NowUIColors.info, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 12,
                          bottom: 12,
                        ),
                      ),
                      onPressed: () {
                        // Respond to button press
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text("INFO", style: TextStyle(fontSize: 14.0)),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: NowUIColors.white, // Text color
                        backgroundColor:
                            NowUIColors.success, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 12,
                          bottom: 12,
                        ),
                      ),
                      onPressed: () {
                        // Respond to button press
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text("SUCCESS", style: TextStyle(fontSize: 14.0)),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: NowUIColors.white, // Text color
                        backgroundColor:
                            NowUIColors.warning, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 12,
                          bottom: 12,
                        ),
                      ),
                      onPressed: () {
                        // Respond to button press
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text("WARNING", style: TextStyle(fontSize: 14.0)),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: NowUIColors.white, // Text color
                        backgroundColor:
                            NowUIColors.error, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 12,
                          bottom: 12,
                        ),
                      ),
                      onPressed: () {
                        // Respond to button press
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Text("ERROR", style: TextStyle(fontSize: 14.0)),
                    ),
                  ),
                ),
                // Additional components like Typography, Inputs, Switches, Navigation, and Table Cell can be placed below
              ],
            ),
          ),
        ),
      ),
    );
  }
}
