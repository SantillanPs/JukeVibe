import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 115, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Library",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // User profile section
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
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
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://picsum.photos/200?random=user',
                              ),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: const Color.fromARGB(255, 243, 109, 201),
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "User Name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "View Profile",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 243, 109, 201),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Premium",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Menu items
                  MenuSection(
                    title: "Your Music",
                    items: [
                      MenuItem(icon: Icons.favorite, title: "Liked Songs"),
                      MenuItem(icon: Icons.playlist_play, title: "Playlists"),
                      MenuItem(icon: Icons.album, title: "Albums"),
                      MenuItem(icon: Icons.person, title: "Artists"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  MenuSection(
                    title: "Settings",
                    items: [
                      MenuItem(icon: Icons.settings, title: "Settings"),
                      MenuItem(icon: Icons.history, title: "History"),
                      MenuItem(icon: Icons.download, title: "Downloads"),
                      MenuItem(
                        icon: Icons.help_outline,
                        title: "Help & Support",
                      ),
                    ],
                  ),

                  const SizedBox(height: 80), // Space for mini player
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuSection extends StatelessWidget {
  final String title;
  final List<MenuItem> items;

  const MenuSection({Key? key, required this.title, required this.items})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children:
                items.map((item) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(item.icon, color: Colors.white),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      if (items.last != item)
                        Divider(
                          color: Colors.white.withOpacity(0.1),
                          height: 1,
                          indent: 70,
                          endIndent: 20,
                        ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;

  MenuItem({required this.icon, required this.title});
}
