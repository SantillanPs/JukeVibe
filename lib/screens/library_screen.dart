import 'package:flutter/material.dart';
import '../utils/theme_provider.dart';

class LibraryScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const LibraryScreen({Key? key, required this.themeProvider})
    : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Your Library'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color.fromARGB(255, 243, 109, 201),
          tabs: const [
            Tab(text: 'Playlists'),
            Tab(text: 'Artists'),
            Tab(text: 'Albums'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildPlaylistsTab(), _buildArtistsTab(), _buildAlbumsTab()],
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100), // Space for mini player
      itemCount: 20,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(
                  255,
                  243,
                  109,
                  201,
                ).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ListTile(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    243,
                    109,
                    201,
                  ).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.favorite, color: Colors.white),
              ),
              title: const Text('Liked Songs'),
              subtitle: const Text('Playlist • 123 songs'),
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                'https://picsum.photos/56?random=$index',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Playlist ${index}'),
            subtitle: Text(
              index % 2 == 0 ? 'Playlist • By You' : 'Playlist • By Artist',
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtistsTab() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100), // Space for mini player
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(
                    255,
                    243,
                    109,
                    201,
                  ).withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://picsum.photos/56?random=${index + 100}',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text('Artist ${index + 1}'),
            subtitle: const Text('Artist'),
          ),
        );
      },
    );
  }

  Widget _buildAlbumsTab() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100), // Space for mini player
      itemCount: 20,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                'https://picsum.photos/56?random=${index + 200}',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Album ${index + 1}'),
            subtitle: Text('Artist ${index + 1}'),
          ),
        );
      },
    );
  }
}
