import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';

class PortfolioGridWidget extends StatelessWidget {
  final Bs4Element content;
  final int columns;
  final double spacing;

  /// Creates a customizable grid for displaying portfolio items with zoomable image functionality.
  const PortfolioGridWidget({
    Key? key,
    required this.content,
    this.columns = 3, // Default to 3 columns
    this.spacing = 8.0, // Default spacing between items
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = content.findAll('div', class_: 'col elastic-portfolio-item regular element');
    final List<Widget> imageWidgets = [];

    for (var item in items) {
      final imgElement = item.find('img');
      final imgSrc = imgElement?.attributes['src'] ?? '';
      final fullImageLink = item.find('a')?.attributes['href'] ?? '';
      final altText = imgElement?.attributes['alt'] ?? 'Image';

      if (imgSrc.isNotEmpty) {
        imageWidgets.add(
          GestureDetector(
            onTap: () {
              _showImageDialog(context, fullImageLink.isNotEmpty ? fullImageLink : imgSrc, altText);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6.0,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                imgSrc,
                fit: BoxFit.cover,
                semanticLabel: altText,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns, // Number of columns
          crossAxisSpacing: spacing, // Horizontal spacing between items
          mainAxisSpacing: spacing, // Vertical spacing between items
        ),
        itemCount: imageWidgets.length,
        itemBuilder: (context, index) => imageWidgets[index],
      ),
    );
  }

  /// Displays an enlarged image with zooming capability using InteractiveViewer.
  void _showImageDialog(BuildContext context, String imageUrl, String altText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87,
          insetPadding: const EdgeInsets.all(10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                maxScale: 5.0,
                minScale: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
