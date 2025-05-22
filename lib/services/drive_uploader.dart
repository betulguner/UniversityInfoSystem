import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter/services.dart' show rootBundle;

class DriveUploader {
  final String credentialsFilePath;
  final String folderId;

  DriveUploader({
    required this.credentialsFilePath,
    required this.folderId,
    
  });

  Future<http.Client> _getHttpClient() async {
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(
        await File(credentialsFilePath).readAsString());

    final client = await auth.clientViaServiceAccount(
      accountCredentials,
      [drive.DriveApi.driveFileScope],
    );

    return client;
  }

  Future<drive.File> uploadImage(File image, {String? fileName}) async {
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(
        await File(credentialsFilePath).readAsString());

    final client = await auth.clientViaServiceAccount(
      accountCredentials,
      [drive.DriveApi.driveFileScope],
    );

    final driveApi = drive.DriveApi(client);

    final drive.File fileToUpload = drive.File();
    fileToUpload.parents = [folderId];
    if (fileName != null) {
      fileToUpload.name = fileName;
    }

    final media = drive.Media(image.openRead(), image.lengthSync());

    final uploadedFile = await driveApi.files.create(
      fileToUpload,
      uploadMedia: media,
    );

    return uploadedFile;
  }

  Future<void> deleteFile(String fileId) async {
    final client = await _getHttpClient();
    final driveApi = drive.DriveApi(client);
    
    try {
      await driveApi.files.delete(fileId);
    } catch (e) {
      throw Exception('Failed to delete file from Drive: $e');
    }
  }

  Future<String> getImageUrl(String fileId) async {
    final client = await _getHttpClient();
    final driveApi = drive.DriveApi(client);
    
    try {
      // Get the file metadata
      final file = await driveApi.files.get(fileId,
          $fields: 'webContentLink,webViewLink') as drive.File;

      // The webContentLink needs to be modified to allow direct viewing
      String? directLink = file.webContentLink;
      if (directLink != null) {
        // Convert the download link to a view link
        directLink = directLink.replaceAll('&export=download', '');
        return directLink;
      }
      
      if (file.webViewLink != null) {
        return file.webViewLink!;
      }

      throw Exception('No viewable link found for file');
    } catch (e) {
      throw Exception('Failed to get image URL from Drive: $e');
    }
  }
}





// https://drive.google.com/drive/folders/1yP7uUxxDSujh1JJMgQRpMsBAyMw5DRir?usp=sharing