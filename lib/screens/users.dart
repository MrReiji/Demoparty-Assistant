import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:demoparty_assistant/data/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:flag/flag.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Map<String, String>> users = [];
  List<Map<String, String>> filteredUsers = [];
  Map<String, int> countryStats = {};
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  String? selectedCountry;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    searchController.addListener(_filterUsers);
  }

  /// Fetches user data and updates the state.
  Future<void> fetchUsers() async {
    setState(() => isLoading = true);

    try {
      users = await UsersService.fetchUsers();
      _calculateCountryStats();
      filteredUsers = List.from(users);
    } catch (e) {
      print('Error fetching users: $e');
    }

    setState(() => isLoading = false);
  }

  /// Calculates the statistics for users by country.
  void _calculateCountryStats() {
    countryStats.clear();
    for (var user in users) {
      final country = user['country'] ?? 'Unknown';
      countryStats[country] = (countryStats[country] ?? 0) + 1;
    }
  }

  /// Filters the users based on the search query or selected country.
  void _filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        final matchesQuery = user['name']!.toLowerCase().contains(query) ||
            user['country']!.toLowerCase().contains(query);
        final matchesCountry =
            selectedCountry == null || user['country'] == selectedCountry;
        return matchesQuery && matchesCountry;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      drawer: AppDrawer(currentPage: 'Users'),
      body: isLoading
          ? _buildLoadingIndicator(theme)
          : Column(
              children: [
                _buildSearchBar(theme),
                _buildStatistics(theme),
                _buildUserList(theme),
              ],
            ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: 20),
          Text(
            'Loading users...',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search users by name or country...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
        ),
      ),
    );
  }

  /// Builds a widget to display statistics about users.
  Widget _buildStatistics(ThemeData theme) {
    final totalUsers = users.length;
    final countries = countryStats.keys.toList();
    countries.sort((a, b) => countryStats[b]!.compareTo(countryStats[a]!));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Users: $totalUsers',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: countries.map((country) {
              final count = countryStats[country]!;
              final isSelected = country == selectedCountry;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedCountry == country) {
                      selectedCountry = null; // Deselect if already selected
                    } else {
                      selectedCountry = country; // Select new country
                    }
                    _filterUsers();
                  });
                },
                child: Chip(
                  label: Text(
                    '$country ($count)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  backgroundColor: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceVariant,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(ThemeData theme) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return _buildUserCard(theme, user);
        },
      ),
    );
  }

  Widget _buildUserCard(ThemeData theme, Map<String, String> user) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: ClipOval(
          child: Flag.fromString(
            user['countryCode']!.toUpperCase(),
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          user['name']!,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          user['country']!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
