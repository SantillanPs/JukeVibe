import 'package:flutter/material.dart';

class SongGallery extends StatelessWidget {
  final bool isRecommended;

  const SongGallery({Key? key, this.isRecommended = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return SongCard(
            title: isRecommended ? 'Mix ${index + 1}' : 'Song ${index + 1}',
            subtitle:
                isRecommended
                    ? 'Based on your listening'
                    : 'Artist ${index + 1}',
            imageUrl:
                'https://picsum.photos/200?random=${isRecommended ? index + 50 : index + 20}',
            isRecommended: isRecommended,
          );
        },
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isRecommended;

  const SongCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.isRecommended = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(
                    255,
                    243,
                    109,
                    201,
                  ).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (isRecommended) ...[
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: const Color.fromARGB(255, 243, 109, 201),
                  size: 14,
                ),
                const SizedBox(width: 5),
                Text(
                  "Recommended for you",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
