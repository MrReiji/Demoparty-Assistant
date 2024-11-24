import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;

class UsersService {
  /// Fetches the list of users from the website.
  static Future<List<Map<String, String>>> fetchUsers() async {
    final List<Map<String, String>> users = [];

    try {
      final response = await http.get(Uri.parse('https://party.xenium.rocks/visitors'));

      if (response.statusCode == 200) {
        final BeautifulSoup soup = BeautifulSoup(response.body);
        final userList = soup.find('ul', class_: 'list-unstyled');
        final userItems = userList?.findAll('li') ?? [];

        for (var item in userItems) {
          final name = item.text.trim();
          final flagElement = item.find('i', class_: 'flag-');
          final countryCode = flagElement?.className.split('-').last ?? '';
          final countryName = flagElement?.attributes['title'] ?? '';

          if (name.isNotEmpty && countryName.isNotEmpty) {
            users.add({
              'name': name,
              'country': countryName,
              'countryCode': countryCode,
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching users: $e');
    }

    return users;
  }
}
