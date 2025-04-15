import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/search_screen.dart';
import 'screens/library_screen.dart';
import 'screens/player_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/user_list_screen.dart';
import 'utils/theme_provider.dart';
import 'controllers/user_controller.dart';
import 'screens/data_export_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MyApp> {
  final ThemeProvider _themeProvider = ThemeProvider();
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _themeProvider.addListener(_themeListener);
    _initUserController();
  }

  Future<void> _initUserController() async {
    // Ensure the app has initialized before loading data
    WidgetsFlutterBinding.ensureInitialized();

    await _userController.init();
  }

  @override
  void dispose() {
    _themeProvider.removeListener(_themeListener);
    super.dispose();
  }

  void _themeListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
        ChangeNotifierProvider.value(value: _userController),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JukeVibe',
        theme: _themeProvider.currentTheme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(themeProvider: _themeProvider),
          '/register':
              (context) => RegisterScreen(themeProvider: _themeProvider),
          '/home': (context) => MainScreen(themeProvider: _themeProvider),
          '/users': (context) => UserListScreen(themeProvider: _themeProvider),
          '/data-export':
              (context) => DataExportScreen(themeProvider: _themeProvider),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const MainScreen({Key? key, required this.themeProvider}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isPlayerVisible = false;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initScreens();
  }

  void _initScreens() {
    _screens = [
      HomeScreen(themeProvider: widget.themeProvider),
      SearchScreen(themeProvider: widget.themeProvider),
      LibraryScreen(themeProvider: widget.themeProvider),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeProvider.isDarkMode;
    final textColor =
        isDark ? Colors.white : const Color.fromARGB(255, 37, 38, 66);
    final shadowColor = const Color.fromARGB(255, 243, 109, 201);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "JukeVibe",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 27,
            shadows: [
              Shadow(color: shadowColor.withAlpha(178), blurRadius: 15),
              Shadow(color: shadowColor.withAlpha(128), blurRadius: 25),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            color: textColor,
            onPressed: () {
              Navigator.pushNamed(context, '/users');
            },
          ),
          IconButton(
            icon: Icon(
              widget.themeProvider.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: textColor,
            ),
            onPressed: () {
              widget.themeProvider.toggleTheme();
            },
          ),
        ],
        shape: Border(bottom: BorderSide(color: shadowColor.withAlpha(178))),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.themeProvider.backgroundGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main content
          _screens[_selectedIndex],

          // Mini player at bottom
          if (_isPlayerVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 10, // Above bottom navigation
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              PlayerScreen(themeProvider: widget.themeProvider),
                    ),
                  );
                },
                child: MiniPlayer(themeProvider: widget.themeProvider),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color:
              isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.white.withOpacity(0.7),
          border: Border(
            top: BorderSide(
              color: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color.fromARGB(255, 243, 109, 201),
          unselectedItemColor: isDark ? Colors.grey : Colors.grey.shade600,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _isPlayerVisible = true; // Show player after navigation
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music),
              label: 'Library',
            ),
          ],
        ),
      ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MiniPlayer({Key? key, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = themeProvider.isDarkMode;
    final backgroundColor =
        isDark ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.7);
    final textColor =
        isDark ? Colors.white : const Color.fromARGB(255, 37, 38, 66);
    final subtitleColor = isDark ? Colors.grey : Colors.grey.shade600;

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Album art
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Image.network(
              'https://picsum.photos/200',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          // Song info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Song Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Artist Name',
                    style: TextStyle(color: subtitleColor, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // Controls
          IconButton(
            icon: Icon(Icons.skip_previous, color: textColor, size: 20),
            onPressed: () {},
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 243, 109, 201),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ),
          IconButton(
            icon: Icon(Icons.skip_next, color: textColor, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
