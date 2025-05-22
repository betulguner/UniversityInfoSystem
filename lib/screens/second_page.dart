import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/campus_data.dart';
import '../services/drive_uploader.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../home_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  String? _selectedCampus;
  String? _selectedUnit;
  String? _selectedBuilding;
  String? _selectedUsingUnit;
  String? selectedUsage;
  String? selectedClassType;

  File? selectedImage;

  final _roomTypeController = TextEditingController();
  final _roomNameController = TextEditingController();
  final _areaController = TextEditingController();
  final _unnamedSectionController = TextEditingController();
  final _toiletCountController = TextEditingController();
  final _notesController = TextEditingController();

  List<String> availableBuildings = [];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<bool> _checkIfRoomExists(Map<String, dynamic> newData) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('oda_kayitlari')
        .where('kampus', isEqualTo: newData['kampus'])
        .where('birimler', isEqualTo: newData['birimler'])
        .where('bina', isEqualTo: newData['bina'])
        .where('kullananBirim', isEqualTo: newData['kullananBirim'])
        .where('odaKodu', isEqualTo: newData['odaKodu'])
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> getServiceAccountPath() async {
    final byteData = await rootBundle.load('assets/bvyo-f3df0-3fb89df0ad47.json');    final file = File('${(await getTemporaryDirectory()).path}/service_account.json');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      String? driveFileId;
      
      // Upload image to Drive if selected
      if (selectedImage != null) {
        final credentialsPath = await getServiceAccountPath();
        final driveUploader = DriveUploader(
          credentialsFilePath: credentialsPath,
          folderId: '1yP7uUxxDSujh1JJMgQRpMsBAyMw5DRir',
        );
        // Dosya adını dinamik oluştur
        String fileName = (_selectedBuilding ?? 'Bina') + '_' + _roomTypeController.text + '.jpg';
        try {
          final uploadedFile = await driveUploader.uploadImage(selectedImage!, fileName: fileName);
          driveFileId = uploadedFile.id;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fotoğraf Drive\'a başarıyla yüklendi')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Drive\'a yükleme hatası: $e')),
          );
          setState(() {
            _isSaving = false;
          });
          return; // Stop the save process if Drive upload fails
        }
      }

      final newEntry = {
        'birimler': _selectedUnit,
        'kampus': _selectedCampus,
        'bina': _selectedBuilding,
        'kullananBirim': _selectedUsingUnit,
        'kullanimAmaci': selectedUsage,
        'odaKodu': _roomTypeController.text,
        'odaTuru': _roomNameController.text,
        'odaKapasitesi': _roomNameController.text,
        'metrekare': _areaController.text,
        'tuvaletSayisi': _toiletCountController.text,
        'sinifTuru': selectedClassType,
        'notlar': _notesController.text,
        'fotoPath': selectedImage?.path,
        'driveFileId': driveFileId, // Store the Drive file ID
        'timestamp': FieldValue.serverTimestamp(),
      };

      bool roomExists = await _checkIfRoomExists(newEntry);
      if (roomExists) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Uyarı'),
            content: const Text('Bu veri zaten mevcut! Lütfen farklı bir oda giriniz.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('oda_kayitlari').add(newEntry);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veriler başarıyla kaydedildi')),
      );

      // Formu temizle
      _formKey.currentState?.reset();
      setState(() {
        _selectedCampus = null;
        _selectedUnit = null;
        _selectedBuilding = null;
        _selectedUsingUnit = null;
        selectedUsage = null;
        selectedClassType = null;
        selectedImage = null;
      });
    

      // Ana sayfaya yönlendir
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _uploadToDrive() async {
    if (selectedImage != null) {
      final driveUploader = DriveUploader(
        credentialsFilePath: 'bvyo_app/assets/client_secret_408689466375-7sp9al5visia7k4i9spg0h1b0m2vae21.apps.googleusercontent.com.json', 
        folderId: '1yP7uUxxDSujh1JJMgQRpMsBAyMw5DRir', 
      );

      try {
        final uploadedFile = await driveUploader.uploadImage(selectedImage!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded to Drive: ${uploadedFile.name}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading file: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _roomTypeController.dispose();
    _roomNameController.dispose();
    _areaController.dispose();
    _unnamedSectionController.dispose();
    _toiletCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Kayıt Ekle', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[700],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('1. Kısım: Temel Bilgiler',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 16),

              const Text('Yerleşke Adı *'),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedCampus,
                hint: const Text('Seçiniz'),
                items: CampusData.campuses.map((String campus) {
                  return DropdownMenuItem<String>(
                    value: campus,
                    child: Text(campus),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCampus = newValue;
                    _selectedUnit = null;
                    _selectedBuilding = null;
                    _selectedUsingUnit = null;
                    availableBuildings = [];
                  });
                },
                validator: (value) => value == null ? 'Lütfen yerleşke seçin' : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Birim Adı *'),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedUnit,
                hint: const Text('Seçiniz'),
                items: CampusData.units.map((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: _selectedCampus == null
                    ? null
                    : (String? newValue) {
                        setState(() {
                          _selectedUnit = newValue;
                          _selectedBuilding = null;
                          _selectedUsingUnit = null;
                          if (newValue != null && _selectedCampus != null) {
                            availableBuildings = CampusData.usingUnitsByCampusAndUnit[_selectedCampus!]?[newValue] ?? [];
                          } else {
                            availableBuildings = [];
                          }
                        });
                      },
                validator: (value) => value == null ? 'Lütfen birim seçin' : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Bina Adı *'),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Bina Adı',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  fillColor: Colors.white,
                  filled: true,
                ),
                value: _selectedBuilding,
                items: availableBuildings.map((building) {
                  return DropdownMenuItem<String>(
                    value: building,
                    child: Text(building),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBuilding = newValue;
                    _selectedUsingUnit = null;
                  });
                },
                validator: (value) => value == null ? 'Lütfen bina seçin' : null,
              ),
              const SizedBox(height: 16),

              const Text('Kullanan Birim *'),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Kullanan Birim',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  fillColor: Colors.white,
                  filled: true,
                ),
                value: _selectedUsingUnit,
                items: _selectedBuilding != null
                    ? (CampusData.buildingsAndUsers[_selectedBuilding!] ?? [])
                        .map((unit) => DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit, overflow: TextOverflow.ellipsis, maxLines: 2),
                            ))
                        .toList()
                    : [],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUsingUnit = newValue;
                  });
                },
                isExpanded: true,
                validator: (value) => value == null ? 'Lütfen kullanan birim seçin' : null,
              ),
              const SizedBox(height: 16),

              const Text('Kapalı Alan Kullanım Amacı *'),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedUsage,
                hint: const Text('Seçiniz'),
                items: [
                  'Eğitim', 'Araştırma', 'Yönetim', 'Sağlık Hizmeti', 'Kütüphane',
                  'Toplantı/Konferans Salonu Alanı', 'Sosyal Alanlar', 'Spor Alanları',
                  'Ticari Alanlar', 'Barınma', 'Islak Hacimler', 'Sirkülasyon Alanları',
                  'Otopark', 'Tuvalet / Pisuvar / Klozet sayısı', 'Diğer'
                ].map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis, maxLines: 2),
                )).toList(),
                onChanged: (val) => setState(() => selectedUsage = val),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Updated TextField styling
              TextFormField(
                controller: _roomTypeController,
                decoration: InputDecoration(
                  labelText: 'Oda Kodu *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  fillColor: Colors.white,
                  filled: true,
                  labelStyle: TextStyle(color: Colors.blue[700]),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Oda kodu boş bırakılamaz' : null,
              ),
              const SizedBox(height: 16),

              // Room Name Field
              TextField(
                controller: _roomNameController,
                decoration: InputDecoration(
                  labelText: 'Oda Kapasitesi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  fillColor: Colors.white,
                  filled: true,
                  labelStyle: TextStyle(color: Colors.blue[700]),
                ),
              ),
              const SizedBox(height: 16),

              // Area Field
              TextField(
                controller: _areaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Odanın Metrekaresi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  fillColor: Colors.white,
                  filled: true,
                  labelStyle: TextStyle(color: Colors.blue[700]),
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(onPressed: _pickImage, child: const Text('Fotoğraf Çek')),
              const SizedBox(height: 16),

              if (selectedImage != null)
                Image.file(selectedImage!, width: 100, height: 100, fit: BoxFit.cover),
                
              const SizedBox(height: 32),

              // Class Type Dropdown visibility
              Visibility(
                visible: selectedUsage == 'Eğitim',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sınıf Türü'),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedClassType,
                      hint: const Text('Seçiniz'),
                      items: ['Amfi', 'Sınıf', 'Laboratuvar', 'Kütüphane', 'Diğer']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedClassType = val),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // Toilet count visibility
              Visibility(
                visible: selectedUsage == 'Tuvalet / Pisuvar / Klozet sayısı',
                child: Column(
                  children: [
                    TextField(
                      controller: _toiletCountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Tuvalet / Pisuvar / Klozet Sayısı',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          fillColor: Colors.white,
                          filled: true,
                          labelStyle: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveEntry,
                child: _isSaving 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}