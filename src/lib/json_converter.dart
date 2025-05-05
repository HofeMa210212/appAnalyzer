
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

 class JsonConverter{
  static Future<String> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      return selectedDirectory;
    } else {
      print("Abgebrochen");
    }
    return "";
  }


  static Future<List<String>> searchFile(String folderPath, String pattern) async {
    final dir = Directory(folderPath);
    List<String> paths = [];

    final regex = RegExp(pattern);

    if (!await dir.exists()) {
      print("Ordner existiert nicht.");
      return [];
    }

    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        String name = entity.uri.pathSegments.last;
        final match = regex.firstMatch(name);

        if (match != null) {
          int year1 = int.parse(match.group(2)!);
          int year2 = int.parse(match.group(3)!);
          if (year2 - year1 == 1) {
            paths.add(entity.path);
          }
        }
      }
    }

    return paths;
  }


  static Future<List<String>> searchDirectory(String folderPath, String directoryName, bool exactName) async {
    final dir = Directory(folderPath);
    List<String> paths = [];

    if (!await dir.exists()) {
      print("Ordner existiert nicht.");
      return [];
    }

    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        String name = entity.uri.pathSegments.last;
        if (exactName && name == directoryName) {
          paths.add(entity.path);
        }
        if (!exactName && name.contains(directoryName)) {
          paths.add(entity.path);
        }
      }
    }

    return paths;
  }


  static Future<String> pickAndUnzipeFile() async {
    bool emulator = false;

    if(!emulator) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, // <---- ganz wichtig!
        allowedExtensions: ['zip', 'json'], // oder was du brauchst
        allowMultiple: false,
      );


      if (result != null && result.files.single.path != null) {
        String zipPath = result.files.single.path!;
        String path = await unzipFile(zipPath);
        return path;
      }
    }else{
      String zipPath = "/data/data/com.example.instagramanalyzer/files/instagram-marvinhofer8-2025-04-14-kaWrMMcr.zip";
      String path = await unzipFile(zipPath);
      return path;
    }


    return "";

  }

  static Future<String> unzipFile(String zipPath) async {
    final bytes = File(zipPath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    final dir = await getApplicationDocumentsDirectory(); // App-interner Speicher
    final extractPath = "${dir.path}/unzipped";

    // Ordner erstellen, wenn er noch nicht existiert
    final unzippedFolder = Directory(extractPath);
    if (!unzippedFolder.existsSync()) {
      await unzippedFolder.create(recursive: true);
    }

    String? extractedFolderName;

    // Entpacken der Dateien
    for (final file in archive) {
      final filename = '$extractPath/${file.name}';

      // Nur den ersten Ordnernamen extrahieren
      if (file.isDirectory && extractedFolderName == null) {
        extractedFolderName = filename;
      }

      if (file.isFile) {
        final outFile = File(filename);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      } else if (file.isDirectory) {
        await Directory(filename).create(recursive: true);
      }
    }

    return extractedFolderName ?? extractPath;
  }

  static Future<List<Map<String, dynamic>>> convertJsonFromFile({required String path, String? key}) async {
    final file = File(path);
    var list;
    if (await file.exists()) {
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents);

      if(key != null){
        list = jsonData[key];
      }else{
        list = jsonData;
      }

      if (list is List) {
        return List<Map<String, dynamic>>.from(list);
      } else {
        throw Exception("Expected a list");
      }
    } else {
      throw Exception("File not found");
    }
  }

}