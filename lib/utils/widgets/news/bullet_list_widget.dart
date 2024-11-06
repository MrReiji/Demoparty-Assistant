import 'package:flutter/material.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class BulletListWidget extends StatelessWidget {
  final Bs4Element ulElement;

  const BulletListWidget({required this.ulElement});

  @override
  Widget build(BuildContext context) {
    print('Building BulletListWidget');
    final liElements = ulElement.findAll('li');
    print('Found ${liElements.length} list items');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: liElements.map((liElement) {
        print('Processing list item: ${liElement.text}');
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• ", style: Theme.of(context).textTheme.bodyLarge),
              Expanded(
                child: Text(
                  liElement.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.6),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
