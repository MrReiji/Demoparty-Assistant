import 'package:demoparty_assistant/constants/drawer_items.dart';
import 'package:demoparty_assistant/utils/navigation/app_router_paths.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer-subtile.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer-tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatefulWidget {
  final String currentPage;

  AppDrawer({required this.currentPage});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? _expandedSection;

  void _toggleExpansion(String section) {
    setState(() {
      _expandedSection = (_expandedSection == section) ? null : section;
    });
  }

  List<Widget> _buildDrawerTiles() {
    return drawerItems.map((item) {
      bool hasSubItems = item.containsKey('subItems');
      bool isExpanded = _expandedSection == item['title'];
      bool isSelected = widget.currentPage.toLowerCase() == item['page']?.toString().toLowerCase();

      if (!hasSubItems) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          child: DrawerTile(
            icon: item['icon'],
            title: item['title'],
            isSelected: isSelected,
            iconColor: item['iconColor'],
            onTap: () {
              if (item['route'] != null) {
                if (widget.currentPage != item['page']) {
                  context.go(item['route']);
                }
              } else if (item['url'] != null) {
                context.go('${AppRouterPaths.content}?url=${Uri.encodeComponent(item['url'])}&title=${Uri.encodeComponent(item['title'])}');
              } else {
                // Obsłuż przypadek, gdy nie ma ani route, ani url
              }
            },
          ),
        );
      }

      bool isAnySubItemSelected = item['subItems'].any((subItem) {
        return widget.currentPage == subItem['page'];
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
            child: DrawerTile(
              icon: item['icon'],
              title: item['title'],
              isSelected: isAnySubItemSelected,
              iconColor: item['iconColor'],
              onTap: () {
                _toggleExpansion(item['title']);
              },
            ),
          ),
          if (isExpanded)
            ...item['subItems'].map<Widget>((subItem) {
              bool isSubItemSelected = widget.currentPage == subItem['page'];
              return Padding(
                padding: const EdgeInsets.only(left: 28.0, top: 2.0, bottom: 2.0, right: 6),
                child: SubDrawerTile(
                  icon: subItem['icon'],
                  title: subItem['title'],
                  isSelected: isSubItemSelected,
                  iconColor: subItem['iconColor'],
                  onTap: () {
                    if (subItem['route'] != null) {
                      if (widget.currentPage != subItem['page']) {
                        context.go(subItem['route']);
                      }
                    } else if (subItem['url'] != null) {
                      context.go('${AppRouterPaths.content}?url=${Uri.encodeComponent(subItem['url'])}&title=${Uri.encodeComponent(subItem['title'])}');
                    } else {
                      // Obsłuż przypadek, gdy nie ma ani route, ani url
                    }
                  },
                ),
              );
            }).toList(),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/imgs/xenium_logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: theme.iconTheme.color?.withOpacity(0.82),
                          size: 24.0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildDrawerTiles(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
