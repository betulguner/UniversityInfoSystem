import 'package:flutter/material.dart';

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
          if (data['fotoPath'] != null && data['fotoPath'].toString().startsWith('http'))
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                data['fotoPath'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 100),
              ),
            )
          else if (data['fotoPath'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                data['fotoPath'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
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
    );
  }
}