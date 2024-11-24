import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';

class ImageGridWidget extends StatelessWidget {
  final Bs4Element content;
  final int columns;
  final double spacing;

  const ImageGridWidget({
    Key? key,
    required this.content,
    this.columns = 3,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageWidgets = _extractImages(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: imageWidgets.length,
        itemBuilder: (context, index) => imageWidgets[index],
      ),
    );
  }

  List<Widget> _extractImages(BuildContext context) {
    final List<Widget> imageWidgets = [];

    final standardItems = content.findAll('div', class_: 'col elastic-portfolio-item regular element');
    final flickityCells = content.findAll('div', class_: 'cell');

    imageWidgets.addAll(_generateImageWidgets(context, standardItems));
    imageWidgets.addAll(_generateImageWidgets(context, flickityCells));

    return imageWidgets;
  }

  List<Widget> _generateImageWidgets(BuildContext context, List<Bs4Element> elements) {
    return elements.map((element) {
      final imgElement = element.find('img');
      final imgSrc = imgElement?.attributes['src'] ?? '';
      final fullImageLink = imgElement?.attributes['src'] ?? '';
      final altText = imgElement?.attributes['alt'] ?? 'Image';

      if (imgSrc.isEmpty) return const SizedBox.shrink();

      return GestureDetector(
        onTap: () => _showImageDialog(context, fullImageLink, altText),
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
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
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
      );
    }).toList();
  }

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
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
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
