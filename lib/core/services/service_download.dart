import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class DownloadService {
  static final Dio _dio = Dio();

  /// Télécharge un fichier et retourne le chemin
  static Future<String?> downloadFile({
    required String url,
    required String fileName,
    void Function(int progress)? onProgress,
  }) async {
    try {
      // Demander permission (Android)
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Permission refusée');
        }
      }

      // Obtenir le dossier de téléchargement
      final directory = await _getDownloadDirectory();
      final filePath = '${directory.path}/$fileName';

      // Télécharger
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            final progress = ((received / total) * 100).toInt();
            onProgress(progress);
          }
        },
      );

      return filePath;
    } catch (e) {
      print('Erreur téléchargement: $e');
      return null;
    }
  }

  /// Ouvre le fichier téléchargé
  static Future<void> openFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      throw Exception('Impossible d\'ouvrir le fichier');
    }
  }

  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else {
      // iOS
      return await getApplicationDocumentsDirectory();
    }
  }
}