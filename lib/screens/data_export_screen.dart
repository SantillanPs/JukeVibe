import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../utils/theme_provider.dart';
import 'package:share_plus/share_plus.dart';

class DataExportScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const DataExportScreen({Key? key, required this.themeProvider}) : super(key: key);

  @override
  State<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends State<DataExportScreen> {
  bool _isExporting = false;
  String? _exportPath;

  Future<void> _exportData() async {
    setState(() {
      _isExporting = true;
      _exportPath = null;
    });

    try {
      final userController = Provider.of<UserController>(context, listen: false);
      final users = userController.users;
      
      // Convert users to JSON
      final jsonData = users.map((user) => user.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);
      
      // Get the documents directory
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/jukevibe_users_$timestamp.json';
      
      // Write the JSON to a file
      final file = File(filePath);
      await file.writeAsString(jsonString);
      
      setState(() {
        _isExporting = false;
        _exportPath = filePath;
      });
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data exported successfully'),
            backgroundColor: Color.fromARGB(255, 243, 109, 201),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareExportedFile() async {
    if (_exportPath != null) {
      await Share.shareFiles([_exportPath!], text: 'JukeVibe User Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : const Color.fromARGB(255, 37, 38, 66);
    final subtitleColor = isDark ? Colors.white.withOpacity(0.7) : const Color.fromARGB(255, 100, 100, 120);
    final cardBgColor = isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.7);
    final borderColor = isDark 
        ? const Color.fromARGB(255, 243, 109, 201).withOpacity(0.2)
        : const Color.fromARGB(255, 243, 109, 201).withOpacity(0.3);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Management',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: textColor,
            ),
            onPressed: () {
              widget.themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: widget.themeProvider.backgroundGradient,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export User Data',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Export your user data to a JSON file that you can save or share.',
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              
              // Export Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.file_download,
                          color: const Color.fromARGB(255, 243, 109, 201),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Export JSON File',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This will create a JSON file with all your user data that you can use for backup or transfer.',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isExporting ? null : _exportData,
                        icon: Icon(_isExporting ? Icons.hourglass_top : Icons.download),
                        label: Text(_isExporting ? 'Exporting...' : 'Export Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 243, 109, 201),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Show export path if available
              if (_exportPath != null) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Export Successful',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'File saved to:',
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _exportPath!,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _shareExportedFile,
                          icon: const Icon(Icons.share),
                          label: const Text('Share File'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const Spacer(),
              
              // Data location info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Data Storage',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your user data is stored in a JSON file within the app\'s project folder. This data persists between app sessions but will be removed if the app is uninstalled.',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
