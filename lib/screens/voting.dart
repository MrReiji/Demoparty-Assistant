import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_display_widget.dart';
import 'package:demoparty_assistant/utils/widgets/universal/errors/error_helper.dart';
import 'package:demoparty_assistant/utils/widgets/universal/loading/loading_widget.dart';
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

/// VotingScreen displays the current competition status and voting entries
/// based on data fetched from the /pm_competition/vote/live endpoint.
class VotingScreen extends StatefulWidget {
  const VotingScreen({Key? key}) : super(key: key);

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  static const String votingEndpoint =
      'https://party.xenium.rocks/pm_competition/vote/live';
  static const String votingPageUrl =
      'https://party.xenium.rocks/frontend/default/en/voting/live';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String competitionStatus = "Unknown";
  List<Map<String, dynamic>> votingEntries = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchVotingData();
  }

  /// Fetches the session cookie stored in secure storage.
  Future<Map<String, String>> _getHeaders() async {
    final sessionCookie = await _storage.read(key: 'session_cookie');
    if (sessionCookie == null || sessionCookie.isEmpty) {
      throw Exception("Session expired. Please log in again.");
    }
    return {"Cookie": sessionCookie};
  }

  /// Fetches competition and voting entries data from the endpoint.
  Future<void> _fetchVotingData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(votingEndpoint), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Update competition status
        final competition = data['competition'];
        setState(() {
          competitionStatus = competition ?? "No live voting at the moment!";
        });

        // Update entries
        final entries = data['entries'] as List<dynamic>;
        votingEntries = entries.map((entry) {
          return {
            "title": entry['name'] ?? "Unknown",
            "position": "#${entry['sort_position'] ?? 'No Position'}",
          };
        }).toList();
      } else {
        throw Exception("Failed to fetch voting data (HTTP ${response.statusCode})");
      }
    } catch (e) {
      ErrorHelper.handleError(e);
      setState(() {
        errorMessage = ErrorHelper.getErrorMessage(e);
        competitionStatus = "Unknown";
        votingEntries = [];
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Voting"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchVotingData,
            tooltip: "Refresh Data",
          ),
        ],
      ),
      drawer: const AppDrawer(currentPage: "Voting"),
      body: isLoading
          ? const LoadingWidget(
              title: "Loading Voting Data",
              message: "Please wait while we fetch the latest voting data.",
            )
          : errorMessage != null
              ? ErrorDisplayWidget(
                  title: "Error Fetching Data",
                  message: errorMessage!,
                  onRetry: _fetchVotingData,
                )
              : _buildContent(theme),
    );
  }

  /// Builds the main content of the screen when no errors occur.
  Widget _buildContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusSection(theme),
          const SizedBox(height: 20),
          _buildVotingToolButton(theme),
          const SizedBox(height: 20),
          _buildVotingEntries(theme),
        ],
      ),
    );
  }

  /// Builds the voting status display section with clear information for users.
  Widget _buildStatusSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Voting Status:",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          competitionStatus,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: 18,
          ),
        ),
        if (competitionStatus == "No live voting at the moment!")
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "There is currently no active competition. Please check back later.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the button to open the external voting tool.
  Widget _buildVotingToolButton(ThemeData theme) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _openVotingTool(),
        icon: const Icon(Icons.open_in_browser),
        label: const Text("Go to Voting Tool"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          textStyle: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
        ),
      ),
    );
  }

  /// Builds the list of voting entries with better spacing and larger text.
  Widget _buildVotingEntries(ThemeData theme) {
    if (votingEntries.isEmpty) {
      return Center(
        child: Text(
          "No entries available for voting.",
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: votingEntries.length,
      itemBuilder: (context, index) {
        final entry = votingEntries[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              entry["title"]!,
              style: theme.textTheme.headlineSmall?.copyWith(fontSize: 18),
            ),
            subtitle: Text(
              "Position: ${entry["position"]!}",
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  /// Opens the voting tool URL in the default browser.
  void _openVotingTool() async {
    if (await canLaunchUrl(Uri.parse(votingPageUrl))) {
      await launchUrl(Uri.parse(votingPageUrl));
    } else {
      throw Exception("Could not launch $votingPageUrl");
    }
  }
}
