import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'services/drive_uploader.dart';

class RoomDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const RoomDetailPage({super.key, required this.data});

  String getValue(String key) {
    final val = data[key];
    if (val == null || (val is String && val.trim().isEmpty)) {
      return 'Belirtilmemiş';
    }
    return val.toString();
  }

  Future<String> getServiceAccountPath() async {
    final byteData = await rootBundle.load('assets/bvyo-f3df0-3fb89df0ad47.json');
    final file = File('${(await getTemporaryDirectory()).path}/service_account.json');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  Widget buildInfoTile(IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[700]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oda Detayları', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (data['driveFileId'] != null)
            FutureBuilder<String?>(
              future: (() async {
                try {
                  final credentialsPath = await getServiceAccountPath();
                  final driveUploader = DriveUploader(
                    credentialsFilePath: credentialsPath,
                    folderId: '1yP7uUxxDSujh1JJMgQRpMsBAyMw5DRir',
                  );
                  final imageUrl = await driveUploader.getImageUrl(data['driveFileId']);
                  return imageUrl;
                } catch (e) {
                  print('Error getting image URL: $e');
                  return null;
                }
              })(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      snapshot.data!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, size: 100),
                        );
                      },
                    ),
                  );
                }
                return Container(
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                );
              },
            ),

          const SizedBox(height: 16),

          buildInfoTile(Icons.location_city, 'Yerleşke', getValue('kampus')),
          buildInfoTile(Icons.apartment, 'Birim', getValue('birimler')),
          buildInfoTile(Icons.business, 'Bina', getValue('bina')),
          buildInfoTile(Icons.group, 'Kullanan Birim', getValue('kullananBirim')),
          buildInfoTile(Icons.door_front_door, 'Oda Kodu', getValue('odaKodu')),
          buildInfoTile(Icons.people_alt, 'Oda Kapasitesi', getValue('odaKapasitesi')),
          buildInfoTile(Icons.assignment, 'Kullanım Amacı', getValue('kullanimAmaci')),
          buildInfoTile(Icons.square_foot, 'Metrekare', getValue('metrekare')),
          buildInfoTile(Icons.view_column, 'Adsız Bölüm', getValue('adsizBolum')),
          buildInfoTile(Icons.wc, 'Tuvalet / Pisuvar / Klozet Sayısı', getValue('tuvaletSayisi')),
          buildInfoTile(Icons.class_, 'Sınıf Türü', getValue('sinifTuru')),
          buildInfoTile(Icons.note_alt, 'Notlar', getValue('notlar')),
        ],
      ),
    );
  }
}