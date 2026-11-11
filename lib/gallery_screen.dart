
import 'package:flutter/material.dart';

class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  final List<Photo> photos = const [
    Photo(
      asset: 'assets/images/gallery/photo1.webp',
      caption: 'My Dream Dog',
    ),
    Photo(
      asset: 'assets/images/gallery/photo2.jpg',
      caption: 'Kitty Meowww',
    ),
    Photo(
      asset: 'assets/images/gallery/photo3.jpeg',
      caption: 'Festive-KTown',
    ),
    Photo(
      asset: 'assets/images/gallery/photo4.jpg',
      caption: 'Flowers',
    ),
    Photo(
      asset: 'assets/images/gallery/photo5.jpg',
      caption: 'Barbie',
    ),
    Photo(
      asset: 'assets/images/gallery/photo6.jpeg',
      caption: 'iPhone 18 Pro Max',
    ),
  ];

  Future<void> _openPhoto(Photo photo) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoScreen(photo: photo),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        _favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: 160,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      children: [
        for (final photo in photos)
          GestureDetector(
            onTap: () => _openPhoto(photo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          photo.asset,
                          fit: BoxFit.cover,
                          semanticLabel: photo.caption,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.pink.shade50,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.broken_image_outlined,
                                color: Colors.pink,
                                size: 36,
                              ),
                            );
                          },
                        ),
                      ),
                      if (_favoriteAsset == photo.asset)
                        const Positioned(
                          top: 6,
                          right: 6,
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  child: Text(
                    photo.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.caption),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InteractiveViewer(
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.contain,
                    semanticLabel: photo.caption,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.star),
                  label: const Text('Make favorite'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
