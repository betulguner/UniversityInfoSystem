import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const RoomDetailPage({super.key, required this.data});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  String getValue(String key) {
    final val = widget.data[key];
    if (val == null || (val is String && val.trim().isEmpty)) {
      return 'Belirtilmemiş';
    }
    return val.toString();
  }

  Future<String?> _getImageUrl(String bina, String odaKodu) async {
    try {
      // Drive klasör ID'si
      const folderId = '1yP7uUxxDSujh1JJMgQRpMsBAyMw5DRir';
      
      // Dosya adını oluştur
      String fileName = '${bina}_${odaKodu}.jpg';
      print('Aranan dosya: $fileName');

      // Drive'dan görüntülenebilir URL oluştur
      String driveUrl = 'https://drive.google.com/uc?export=view&id=1cRc2UAE9Vy5bmCgxb8QeFS8MlxZ-8PXi';
      print('Drive URL: $driveUrl');
      
      return driveUrl;
    } catch (e) {
      print('Hata: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bina = getValue('bina');
    final odaKodu = getValue('odaKodu');
    
    print('Bina: $bina, Oda Kodu: $odaKodu');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oda Detayları', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: FutureBuilder<String?>(
                future: _getImageUrl(bina, odaKodu),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    print('FutureBuilder hatası: ${snapshot.error}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Hata: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fotoğraf bulunamadı',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        headers: const {
                          'Access-Control-Allow-Origin': '*',
                          'Cache-Control': 'max-age=3600',
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Resim yükleme hatası: $error');
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Fotoğraf yüklenemedi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            buildInfoTile(Icons.location_city, 'Yerleşke', getValue('kampus')),
            buildInfoTile(Icons.apartment, 'Birim', getValue('birimler')),
            buildInfoTile(Icons.business, 'Bina', getValue('bina')),
            buildInfoTile(Icons.group, 'Kullanan Birim', getValue('kullananBirim')),
            buildInfoTile(Icons.door_front_door, 'Oda Kodu', getValue('odaKodu')),
            buildInfoTile(Icons.people_alt, 'Oda Kapasitesi', getValue('odaTuru')),
            buildInfoTile(Icons.assignment, 'Kullanım Amacı', getValue('kullanimAmaci')),
            buildInfoTile(Icons.square_foot, 'Metrekare', getValue('metrekare')),
            buildInfoTile(Icons.view_column, 'Adsız Bölüm', getValue('adsizBolum')),
            buildInfoTile(Icons.wc, 'Tuvalet / Pisuvar / Klozet Sayısı', getValue('tuvaletSayisi')),
            buildInfoTile(Icons.class_, 'Sınıf Türü', getValue('sinifTuru')),
            buildInfoTile(Icons.note_alt, 'Notlar', getValue('notlar')),
          ],
        ),
      ),
    );
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
}