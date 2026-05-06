import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DownloadService {
  static final Dio _dio = Dio();

  /// Vérifie et demande les permissions appropriées selon la version Android
  static Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13+ : permissions spécifiques par type de média
        // Pour les fichiers généraux, on utilise manageExternalStorage ou on sauvegarde dans app directory
        final photos = await Permission.photos.request();
        final videos = await Permission.videos.request();
        final audio = await Permission.audio.request();
        
        // Pour les documents non-médias sur Android 13+, on utilise le directory de l'app
        // ou on demande manageExternalStorage si vraiment nécessaire
        return photos.isGranted || videos.isGranted || audio.isGranted;
      } else {
        // Android 12 et moins
        final storage = await Permission.storage.request();
        return storage.isGranted;
      }
    }
    return true; // iOS gère différemment
  }

  /// Télécharge un fichier et retourne le chemin
  static Future<String?> downloadFile({
    required String url,
    required String fileName,
    void Function(int progress)? onProgress,
  }) async {
    try {
      // Vérifier permissions
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        throw Exception('Permissions refusées pour le téléchargement');
      }

      // Obtenir le dossier de téléchargement approprié
      final directory = await _getDownloadDirectory();
      final filePath = '${directory.path}/$fileName';

      // Vérifier si le fichier existe déjà
      final file = File(filePath);
      if (await file.exists()) {
        // Générer un nom unique
        final extension = fileName.contains('.') ? '.${fileName.split('.').last}' : '';
        final nameWithoutExt = fileName.contains('.') 
            ? fileName.substring(0, fileName.lastIndexOf('.')) 
            : fileName;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final newFileName = '${nameWithoutExt}_$timestamp$extension';
        return downloadFile(url: url, fileName: newFileName, onProgress: onProgress);
      }

      // Télécharger avec suivi de progression
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            final progress = ((received / total) * 100).toInt();
            onProgress(progress);
          }
        },
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      // Scanner le fichier pour qu'il apparaisse dans la galerie/fichiers
      if (Platform.isAndroid) {
        await _scanFile(filePath);
      }

      return filePath;
    } on DioException catch (e) {
      print('Erreur Dio: ${e.message}');
      return null;
    } catch (e) {
      print('Erreur téléchargement: $e');
      return null;
    }
  }

  /// Ouvre le fichier téléchargé
  static Future<void> openFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      throw Exception('Impossible d\'ouvrir le fichier: ${result.message}');
    }
  }

  /// Détermine le répertoire de téléchargement selon la plateforme et la version
  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      
      if (deviceInfo.version.sdkInt >= 33) {
        // Android 13+: utiliser le dossier Documents de l'app ou Downloads public
        final publicDir = Directory('/storage/emulated/0/Download');
        if (await publicDir.exists()) {
          return publicDir;
        }
      }
      
      // Fallback: Downloads public pour Android < 13 ou si public n'existe pas
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (await downloadsDir.exists()) {
        return downloadsDir;
      }
      
      // Dernier recours: directory de l'application
      return await getApplicationDocumentsDirectory();
    } else {
      // iOS: toujours dans l'app directory
      return await getApplicationDocumentsDirectory();
    }
  }

  /// Notifie le système qu'un nouveau fichier est disponible (Android)
  static Future<void> _scanFile(String filePath) async {
    // Note: Pour une implémentation complète, utilisez media_scanner ou similar
    // Cette méthode est un placeholder pour l'intégration avec MediaScanner
  }
}