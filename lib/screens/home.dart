import 'package:flutter/material.dart';
import '../utils/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({Key? key, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = themeProvider.isDarkMode;
    final textColor =
        isDark ? Colors.white : const Color.fromARGB(255, 37, 38, 66);
    final subtitleColor =
        isDark ? Colors.white70 : const Color.fromARGB(255, 100, 100, 120);
    final cardBgColor =
        isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.7);
    final borderColor =
        isDark
            ? const Color.fromARGB(255, 243, 109, 201).withOpacity(0.2)
            : const Color.fromARGB(255, 243, 109, 201).withOpacity(0.3);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced App Bar with greeting
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 150,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: subtitleColor,
                    ),
                  ),
                  Text(
                    'Music Lover',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 243, 109, 201).withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: textColor),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.history, color: textColor),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined, color: textColor),
                onPressed: () {},
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: TextField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Search songs, artists, playlists...',
                    hintStyle: TextStyle(color: subtitleColor),
                    prefixIcon: Icon(Icons.search, color: subtitleColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ),

          // Quick Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip(
                    'For You',
                    isSelected: true,
                    isDark: isDark,
                  ),
                  _buildCategoryChip('Popular', isDark: isDark),
                  _buildCategoryChip('Trending', isDark: isDark),
                  _buildCategoryChip('New Releases', isDark: isDark),
                  _buildCategoryChip('Moods', isDark: isDark),
                  _buildCategoryChip('Genres', isDark: isDark),
                ],
              ),
            ),
          ),

          // Continue Listening Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Continue Listening',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: textColor),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_circle_filled,
                      color: Color.fromARGB(255, 243, 109, 201),
                      size: 16,
                    ),
                    label: const Text(
                      'Play All',
                      style: TextStyle(
                        color: Color.fromARGB(255, 243, 109, 201),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Continue Listening Cards
          SliverToBoxAdapter(
            child: SizedBox(
              height: 190,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ContinueListeningCard(
                    title: 'Song Title ${index + 1}',
                    artist: 'Artist Name',
                    imageUrl: 'https://picsum.photos/200?random=${index + 5}',
                    progress: (index + 1) * 0.15,
                    isDark: isDark,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  );
                },
              ),
            ),
          ),

          // Recently Played Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recently Played',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: textColor),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text('See All', style: TextStyle(color: subtitleColor)),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: subtitleColor,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Enhanced Recently Played Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return RecentlyPlayedItem(
                  title: 'Recently Played ${index + 1}',
                  subtitle: 'Artist ${index + 1}',
                  imageUrl: 'https://picsum.photos/200?random=$index',
                  isDark: isDark,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  cardBgColor: cardBgColor,
                  borderColor: borderColor,
                );
              }, childCount: 6),
            ),
          ),

          // Space for mini player
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    String label, {
    bool isSelected = false,
    required bool isDark,
  }) {
    final textColor =
        isDark ? Colors.white : const Color.fromARGB(255, 37, 38, 66);
    final subtitleColor =
        isDark ? Colors.white70 : const Color.fromARGB(255, 100, 100, 120);
    final chipBgColor =
        isSelected
            ? const Color.fromARGB(255, 243, 109, 201).withOpacity(0.3)
            : isDark
            ? Colors.black.withOpacity(0.2)
            : Colors.white.withOpacity(0.7);
    final chipBorderColor =
        isSelected
            ? const Color.fromARGB(255, 243, 109, 201)
            : isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.withOpacity(0.3);

    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? textColor : subtitleColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        backgroundColor: chipBgColor,
        side: BorderSide(color: chipBorderColor, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}

class RecentlyPlayedItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isDark;
  final Color textColor;
  final Color subtitleColor;
  final Color cardBgColor;
  final Color borderColor;

  const RecentlyPlayedItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isDark,
    required this.textColor,
    required this.subtitleColor,
    required this.cardBgColor,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Image.network(imageUrl, width: 56, height: 56, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: subtitleColor, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.play_circle_filled,
              color: Color.fromARGB(255, 243, 109, 201),
              size: 24,
            ),
            onPressed: () {},
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(right: 12),
          ),
        ],
      ),
    );
  }
}

class ContinueListeningCard extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final double progress;
  final bool isDark;
  final Color textColor;
  final Color subtitleColor;

  const ContinueListeningCard({
    Key? key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.progress,
    required this.isDark,
    required this.textColor,
    required this.subtitleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: const Color.fromARGB(
                      255,
                      243,
                      109,
                      201,
                    ).withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.black.withOpacity(0.5)
                            : Colors.white.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: (progress * 100).toInt(),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 243, 109, 201),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 100 - (progress * 100).toInt(),
                        child: Container(),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.black.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            artist,
            style: TextStyle(color: subtitleColor, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
