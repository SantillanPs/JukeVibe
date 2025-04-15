import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class FileUtils {
  /// Copies a file from assets to a local file that can be read and written to
  static Future<File> getWritableFile(String assetPath, String localFileName) async {
    // Get the application directory
    final directory = await getApplicationDocumentsDirectory();
    
    // Define the local file path
    final localFilePath = '${directory.path}/$localFileName';
    final localFile = File(localFilePath);
    
    // Check if the file already exists
    if (!await localFile.exists()) {
      // If not, copy the asset file to the local path
      try {
        // Read the asset file
        final data = await rootBundle.load(assetPath);
        
        // Write the data to the local file
        final bytes = data.buffer.asUint8List();
        await localFile.writeAsBytes(bytes);
      } catch (e) {
        // If the asset doesn't exist, create an empty file
        await localFile.writeAsString('[]');
      }
    }
    
    return localFile;
  }
  
  /// Reads the content of a JSON file as a string
  static Future<String> readJsonFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return '[]';
    } catch (e) {
      return '[]';
    }
  }
  
  /// Writes content to a JSON file
  static Future<void> writeJsonFile(String filePath, String content) async {
    try {
      final file = File(filePath);
      await file.writeAsString(content);
    } catch (e) {
      throw Exception('Failed to write to file: $e');
    }
  }
}
