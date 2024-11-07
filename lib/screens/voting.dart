import 'package:flutter/material.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;
import 'package:demoparty_assistant/utils/widgets/drawer/drawer.dart';

class Voting extends StatefulWidget {
  final String sessionCookie;

  const Voting({Key? key, required this.sessionCookie}) : super(key: key);

  @override
  _VotingState createState() => _VotingState();
}

class _VotingState extends State<Voting> {
  List<VotingEntry> entries = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchVotingData();
  }

  Future<void> fetchVotingData() async {
    debugPrint("Starting fetchVotingData...");
    if (widget.sessionCookie.isEmpty) {
      setState(() {
        errorMessage = "Session expired. Please log in again.";
        isLoading = false;
      });
      debugPrint("Session cookie is null. Redirecting to login.");
      return;
    }

    final url = Uri.parse("https://party.xenium.rocks/voting");
    final headers = {
      "Cookie": widget.sessionCookie,
    };

    try {
      debugPrint("Sending GET request to $url with headers: $headers");
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        debugPrint("Data fetched successfully. Parsing HTML...");
        debugPrint(response.body);
        parseHtml(response.body);
      } else {
        setState(() {
          errorMessage = "Failed to load data. Status code: ${response.statusCode}";
          isLoading = false;
        });
        debugPrint("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
      debugPrint("Exception occurred during fetchVotingData: $e");
    }
  }

  void parseHtml(String html) {
    debugPrint("Starting parseHtml...");
    final soup = BeautifulSoup(html);
    final List<VotingEntry> fetchedEntries = [];

    final votingEntries = soup.findAll("div", class_: "thumbnail image");
    debugPrint("Found ${votingEntries.length} voting entries.");

    for (var entry in votingEntries) {
      final rankText = entry.find("span", class_: "label")?.text;
      final title = entry.find("b")?.text;
      final author = entry.find("p")?.text;
      final imageUrl = entry.find("img")?.attributes['src'];

      debugPrint("Parsing entry: rank=$rankText, title=$title, author=$author, imageUrl=$imageUrl");

      if (rankText != null && title != null && author != null && imageUrl != null) {
        final rank = int.tryParse(rankText.replaceAll("#", "")) ?? 0;
        fetchedEntries.add(
          VotingEntry(
            rank: rank,
            title: title,
            author: author,
            imageUrl: "https://party.xenium.rocks$imageUrl",
          ),
        );
        debugPrint("Added entry: rank=$rank, title=$title, author=$author, imageUrl=https://party.xenium.rocks$imageUrl");
      } else {
        debugPrint("Incomplete entry data found and skipped.");
      }
    }

    setState(() {
      entries = fetchedEntries;
      isLoading = false;
    });
    debugPrint("parseHtml complete. Total valid entries parsed: ${fetchedEntries.length}");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building Voting screen...");
    return Scaffold(
      appBar: AppBar(
        title: Text('Voting Results'),
      ),
      drawer: AppDrawer(currentPage: "Voting"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return VotingEntryWidget(entry: entries[index]);
                  },
                ),
    );
  }
}

class VotingEntry {
  final int rank;
  final String title;
  final String author;
  final String imageUrl;

  VotingEntry({
    required this.rank,
    required this.title,
    required this.author,
    required this.imageUrl,
  });
}

class VotingEntryWidget extends StatelessWidget {
  final VotingEntry entry;

  const VotingEntryWidget({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Building VotingEntryWidget for entry with rank: ${entry.rank}");
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${entry.rank}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  entry.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text('by ${entry.author}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Image.network(entry.imageUrl, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
