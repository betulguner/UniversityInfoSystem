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
}





// https://drive.google.com/drive/folders/1yP7uUxxDSujh1JJMgQRpMsBAyMw5DRir?usp=sharing



