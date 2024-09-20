import 'package:demoparty_assistant/utils/navigation/app_router_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:demoparty_assistant/constants/Theme.dart';
import 'package:demoparty_assistant/utils/widgets/drawer-tile.dart';

class NowDrawer extends StatelessWidget {
  final String currentPage;

  NowDrawer({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0XFF141414),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width * 0.85,
              child: SafeArea(
                bottom: false,
                top: false,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 55),
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
            Expanded(
              flex: 2,
              child: ListView(
                padding: const EdgeInsets.only(top: 36, left: 8, right: 16),
                children: [
                  DrawerTile(
                    icon: FontAwesomeIcons.calendar,
                    onTap: () {
                      if (currentPage != "Home")
                        context.go(AppRouterPaths.home);
                    },
                    iconColor: NowUIColors.primary,
                    title: "Events",
                    isSelected: currentPage == "Home",
                  ),
                  DrawerTile(
                    icon: FontAwesomeIcons.arrowDownShortWide,
                    onTap: () {
                      if (currentPage != "Components")
                        context.go(AppRouterPaths.components);
                    },
                    iconColor: NowUIColors.error,
                    title: "During The Party",
                    isSelected: currentPage == "Components",
                  ),
                  DrawerTile(
                    icon: FontAwesomeIcons.newspaper,
                    onTap: () {
                      if (currentPage != "News")
                        context.go(AppRouterPaths.news);
                    },
                    iconColor: NowUIColors.primary,
                    title: "News",
                    isSelected: currentPage == "News",
                  ),
                  DrawerTile(
                    icon: FontAwesomeIcons.circleInfo,
                    onTap: () {
                      if (currentPage != "Account")
                        context.go(AppRouterPaths.account);
                    },
                    iconColor: NowUIColors.info,
                    title: "About",
                    isSelected: currentPage == "Account",
                  ),
                  DrawerTile(
                    icon: FontAwesomeIcons.trophy,
                    onTap: () {
                      if (currentPage != "Account")
                        context.go(AppRouterPaths.account);
                    },
                    iconColor: NowUIColors.info,
                    title: "Competitions",
                    isSelected: currentPage == "Account",
                  ),
                  DrawerTile(
                    icon: FontAwesomeIcons.satellite,
                    onTap: () {
                      if (currentPage != "Account")
                        context.go(AppRouterPaths.account);
                    },
                    iconColor: NowUIColors.info,
                    title: "Satellites",
                    isSelected: currentPage == "Account",
                  ),
                  DrawerTile(
                    icon: FontAwesomeIcons.heart,
                    onTap: () {
                      if (currentPage != "Account")
                        context.go(AppRouterPaths.account);
                    },
                    iconColor: NowUIColors.info,
                    title: "Sponsors",
                    isSelected: currentPage == "Account",
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 4,
                      thickness: 0,
                      color: NowUIColors.white.withOpacity(0.8),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 16, bottom: 4),
                      child: Text(
                        "IMPORTANT",
                        style: TextStyle(
                          color: NowUIColors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(top: 0),
                        children: [
                          DrawerTile(
                            icon: FontAwesomeIcons.user,
                            onTap: () {
                              if (currentPage != "Profile")
                                context.go(AppRouterPaths.profile);
                            },
                            iconColor: NowUIColors.warning,
                            title: "Profile",
                            isSelected: currentPage == "Profile",
                          ),
                          DrawerTile(
                            icon: FontAwesomeIcons.cog,
                            onTap: () {
                              if (currentPage != "Settings")
                                context.go(AppRouterPaths.settings);
                            },
                            iconColor: NowUIColors.success,
                            title: "Settings",
                            isSelected: currentPage == "Settings",
                          ),
                          DrawerTile(
                            icon: FontAwesomeIcons.discord,
                            onTap: () {
                              // Dummy tile
                            },
                            iconColor: NowUIColors.success,
                            title: "Discord",
                            isSelected: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
