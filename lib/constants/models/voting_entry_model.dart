class VotingEntry {
  final String title;
  final String author;
  final String imageUrl;
  final int rank;
  final List<int> availableVotes;

  VotingEntry({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rank,
    this.availableVotes = const [1, 2, 3, 4, 5],
  });
}
