import 'package:demoparty_assistant/utils/navigation/app_router_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:demoparty_assistant/utils/widgets/drawer-tile.dart';

class NowDrawer extends StatefulWidget {
  final String currentPage;

  NowDrawer({required this.currentPage});

  @override
  _NowDrawerState createState() => _NowDrawerState();
}

class _NowDrawerState extends State<NowDrawer> {
  bool isAboutExpanded = false;

  // Function to create consistent DrawerTile with standardized horizontal padding
  Widget buildDrawerTile({
    required IconData icon,
    required String title,
    required bool isSelected,
    required Color iconColor,
    GestureTapCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8), // Only horizontal padding
      child: DrawerTile(
        icon: icon,
        title: title,
        isSelected: isSelected,
        iconColor: iconColor,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0XFF141414),
        child: Column(
          children: [
            // Drawer header with logo and close button
            Container(
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width * 0.85,
              child: SafeArea(
                bottom: false,
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Image.asset(
                        "assets/imgs/now-logo.png",
                        scale: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: NowUIColors.white.withOpacity(0.82),
                            size: 24.0,
                          ),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Odstęp między logo a listą (Events)
            const SizedBox(height: 15),
            // Main drawer content with padding above and below the ListView
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildDrawerTile(
                    icon: FontAwesomeIcons.calendar,
                    title: "Events",
                    isSelected: widget.currentPage == "Home",
                    iconColor: NowUIColors.primary,
                    onTap: () {
                      if (widget.currentPage != "Home") context.go(AppRouterPaths.home);
                    },
                  ),
                  buildDrawerTile(
                    icon: FontAwesomeIcons.arrowDownShortWide,
                    title: "During The Party",
                    isSelected: widget.currentPage == "Components",
                    iconColor: NowUIColors.error,
                    onTap: () {
                      if (widget.currentPage != "Components") context.go(AppRouterPaths.components);
                    },
                  ),
                  buildDrawerTile(
                    icon: FontAwesomeIcons.newspaper,
                    title: "News",
                    isSelected: widget.currentPage == "News",
                    iconColor: NowUIColors.primary,
                    onTap: () {
                      if (widget.currentPage != "News") context.go(AppRouterPaths.news);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAboutExpanded = !isAboutExpanded;
                      });
                    },
                    child: buildDrawerTile(
                      icon: FontAwesomeIcons.circleInfo,
                      title: "About",
                      isSelected: false,
                      iconColor: NowUIColors.info,
                    ),
                  ),
                  if (isAboutExpanded) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 36.0),
                      child: buildDrawerTile(
                        icon: FontAwesomeIcons.eye,
                        title: "At a Glance",
                        isSelected: widget.currentPage == "Pro",
                        iconColor: NowUIColors.white.withOpacity(0.6),
                        onTap: () {
                          context.go(AppRouterPaths.pro);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 36.0),
                      child: buildDrawerTile(
                        icon: FontAwesomeIcons.questionCircle,
                        title: "First Time Visitor?",
                        isSelected: false,
                        iconColor: NowUIColors.white.withOpacity(0.6),
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 36.0),
                      child: buildDrawerTile(
                        icon: FontAwesomeIcons.virus,
                        title: "Covid-19 Information",
                        isSelected: false,
                        iconColor: NowUIColors.white.withOpacity(0.6),
                        onTap: () {},
                      ),
                    ),
                  ],
                  buildDrawerTile(
                    icon: FontAwesomeIcons.trophy,
                    title: "Competitions",
                    isSelected: widget.currentPage == "Register",
                    iconColor: NowUIColors.info,
                    onTap: () {
                      if (widget.currentPage != "Register") context.go(AppRouterPaths.register);
                    },
                  ),
                  buildDrawerTile(
                    icon: FontAwesomeIcons.satellite,
                    title: "Satellites",
                    isSelected: widget.currentPage == "Satellites",
                    iconColor: NowUIColors.primary,
                    onTap: () {
                      if (widget.currentPage != "Satellites") context.go(AppRouterPaths.satellites);
                    },
                  ),
                  buildDrawerTile(
                    icon: FontAwesomeIcons.heart,
                    title: "Sponsors",
                    isSelected: widget.currentPage == "Sponsors",
                    iconColor: NowUIColors.info,
                    onTap: () {
                      if (widget.currentPage != "Sponsors") context.go(AppRouterPaths.sponsors);
                    },
                  ),
                ],
              ),
            ),
            // Divider with reduced width
            Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
              child: Divider(
                height: 1,
                thickness: 1,
                color: NowUIColors.white.withOpacity(0.8),
              ),
            ),
            // Bottom section with Profile, Settings, Discord
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 0, left: 16, bottom: 4),
                    child: Text(
                      "IMPORTANT",
                      style: TextStyle(
                        color: NowUIColors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // Lower drawer items
                  ListView(
                    padding: const EdgeInsets.only(top: 0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      buildDrawerTile(
                        icon: FontAwesomeIcons.user,
                        title: "Profile",
                        isSelected: widget.currentPage == "Profile",
                        iconColor: NowUIColors.warning,
                        onTap: () {
                          if (widget.currentPage != "Profile") context.go(AppRouterPaths.profile);
                        },
                      ),
                      buildDrawerTile(
                        icon: FontAwesomeIcons.cog,
                        title: "Settings",
                        isSelected: widget.currentPage == "Settings",
                        iconColor: NowUIColors.success,
                        onTap: () {
                          if (widget.currentPage != "Settings") context.go(AppRouterPaths.settings);
                        },
                      ),
                      buildDrawerTile(
                        icon: FontAwesomeIcons.discord,
                        title: "Discord",
                        isSelected: false,
                        iconColor: NowUIColors.success,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
