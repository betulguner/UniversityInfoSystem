class CampusData {
  static final List<String> campuses = [
    'Merkez Yerleşkesi',
    'Yoncalık Yerleşkesi',
    'Aşkale Yerleşkesi',
    'Hınıs Yerleşkesi',
    'İspir Yerleşkesi',
    'Horasan Yerleşkesi',
    'Narman Yerleşkesi',
    'Oltu Fakülte Yerleşkesi',
    'Oltu MYO Yerleşkesi',
    'Pasinler Yerleşkesi',
    'Tortum Yerleşkesi',
    'Ziraat Fakültesi İş Müdürlüğü' 
  ];

  static final List<String> units = [
    'İdari Birimler',
    'Fakülteler',
    'Enstitüler',
    'Meslek Yüksekokulları',
    'Yüksekokul/Konservatuar'
  ];

  // Kullanan birimler ve binaları
  static final Map<String, Map<String, List<String>>> usingUnitsByCampusAndUnit = {
    'Merkez Yerleşkesi': {
      'Fakülteler': [
        'Açık ve Uzaktan Öğretim Fakültesi',
        'Diş Hekimliği Fakültesi',
        'Eczacılık Fakültesi',
        'Edebiyat Fakültesi',
        'Fen Fakültesi',
        'Güzel Sanatlar Fakültesi',
        'Hemşirelik Fakültesi',
        'Hukuk Fakültesi',
        'İktisadi ve İdari Bilimler Fakültesi',
        'İlahiyat Fakültesi',
        'İletişim Fakültesi',
        'Kazım Karabekir Eğitim Fakültesi',
        'Mimarlık ve Tasarım Fakültesi',
        'Mühendislik Fakültesi',
        'Sağlık Bilimleri Fakültesi',
        'Spor Bilimleri Fakültesi',
        'Su Ürünleri Fakültesi',
        'Tıp Fakültesi',
        'Turizm Fakültesi',
        'Veteriner Fakültesi',
        'Ziraat Fakültesi'
      ],
      'Enstitüler': [
        'Atatürk İlkeleri ve İnkılâp Tarihi Enstitüsü',
        'Eğitim Bilimleri Enstitüsü',
        'Enstitüler Binası',
        'Güzel Sanatlar Enstitüsü',
        'Kış Sporları ve Spor Bilimleri Enstitüsü',
    
      ],
      'Yüksekokul/Konservatuar': [
        'Türk Mûsikîsi Devlet Konservatuvarı',
        'Yabancı Diller Yüksekokulu'
      ],
      'İdari Birimler': [
        'BAUM Binası',
        'Rektörlük Binası',
        'Yapı İşleri ve Teknik Daire Başkanlığı',
        'Araştırma Merkezleri Binası',
        'Konukevi-1',
        'Sağlık Kültür ve Spor Daire Başkanlığı',
        'Biyoçeşitlilik Uygulama ve Araştırma Merkezi',
        'Buz Eserler Müzesi Koordinatörlüğü',
        'İdari ve Mali İşler Daire Başkanlığı',
        'Koruma ve Güvenlik Müdürlüğü',
        'Kütüphane Binası',
        'Manej Alanı ve Atçılık Koordinatörlüğü',
        'Mediko Binası',
        'Okuma Salonu Binası',
        'Öğrenci İşleri Binası',  
        'Türk Mûsikîsi Devlet Konservatuvarı',
        'Yabancı Diller Yüksekokulu',
        'Türkçe Öğretimi Uygulama ve Araştırma Merkezi',
        'Astrofizik Araştırma ve Uygulama Merkezi'

      ]
    },
    'Oltu Fakülte Yerleşkesi': {
      'Fakülteler': [
      'Oltu Fakülte Binası'
      ],
      'İdari Birimler': [
      'Oltu Fakülteler Binası'
      ]
    },
    'Oltu MYO Yerleşkesi': {
      'Meslek Yüksekokulları': [
        'Oltu Meslek Yüksekokulu'
      ],
      'İdari Birimler': [
        'Oltu MYO İdari Binası'
      ]
    },
    'Aşkale Yerleşkesi': {
      'Meslek Yüksekokulları': [
        'Aşkale Meslek Yüksekokulu'
      ],
      'İdari Birimler': [
        'Aşkale Yerleşkesi İdari Binası'
      ]
    },
    'Hınıs Yerleşkesi': {
      'Meslek Yüksekokulları': [
        'Hınıs Meslek Yüksekokulu'
      ],
      'İdari Birimler': [
        'Hınıs Yerleşkesi İdari Binası'
      ]
    },
    'İspir Yerleşkesi': {
      'Meslek Yüksekokulları': [
        'İspir Hamza Polat Meslek Yüksekokulu'
      ],
      'İdari Birimler': [
        'İspir Yerleşkesi İdari Binası'
      ]
    },
    'Horasan Yerleşkesi': {
      'Meslek Yüksekokulları': [
        'Horasan Meslek Yüksekokulu'
      ],
      'İdari Birimler': [
        'Horasan Yerleşkesi İdari Binası'
      ]
    },
    'Narman Yerleşkesi': {
      'Meslek Yüksekokulları': [
        'Narman Meslek Yüksekokulu'
      ],
      'İdari Birimler': [
        'Narman Yerleşkesi İdari Binası'
      ]
    },
    'Pasinler Yerleşkesi': {
      'Meslek Yüksekokulları': [
        'Pasinler Meslek Yüksekokulu'
      ],
      'İdari Birimler': [
        'Pasinler Yerleşkesi İdari Binası'
      ]
    },
    'Tortum Yerleşkesi': {
      'Meslek Yüksekokulları': [
        'Tortum Meslek Yüksekokulu'
      ],
      'İdari Birimler': [
        'Tortum Yerleşkesi İdari Binası'
      ]
    },
    'Yoncalık Yerleşkesi': {
      'İdari Birimler': [
        'Yoncalık Yerleşkesi İdari Binası'
      ]
    },
    'Ziraat Fakültesi İş Müdürlüğü': {
      'İdari Birimler': [
        'Ziraat Fakültesi İş Müdürlüğü Binası'
      ]
    }
  };

  // Binalar ve kullanan birimler
  static final Map<String, List<String>> buildingsAndUsers = {
    'Açık ve Uzaktan Öğretim Fakültesi': ['Açık ve Uzaktan Öğretim Fakültesi'],
    'Diş Hekimliği Fakültesi': ['Diş Hekimliği Fakültesi'],
    'Eczacılık Fakültesi': ['Eczacılık Fakültesi'],
    'Edebiyat Fakültesi': ['Edebiyat Fakültesi'],
    'Fen Fakültesi': ['Fen Fakültesi'],
    'Güzel Sanatlar Fakültesi': ['Güzel Sanatlar Fakültesi'],
    'Hemşirelik Fakültesi': ['Hemşirelik Fakültesi'],
    'Hukuk Fakültesi': ['Hukuk Fakültesi'],
    'İktisadi ve İdari Bilimler Fakültesi': ['İktisadi ve İdari Bilimler Fakültesi'],
    'İlahiyat Fakültesi': ['İlahiyat Fakültesi'],
    'İletişim Fakültesi': ['İletişim Fakültesi'],
    'Kazım Karabekir Eğitim Fakültesi': ['Kazım Karabekir Eğitim Fakültesi'],
    'Mimarlık ve Tasarım Fakültesi': ['Mimarlık ve Tasarım Fakültesi'],
    'Mühendislik Fakültesi': ['Mühendislik Fakültesi','Mühendislik Fakültesi Ek Bina','Öğrenci Dekanlığı'],

    'Sağlık Bilimleri Fakültesi': ['Sağlık Bilimleri Fakültesi'],
    'Spor Bilimleri Fakültesi': ['Spor Bilimleri Fakültesi'],
    'Su Ürünleri Fakültesi': ['Su Ürünleri Fakültesi'],
    'Tıp Fakültesi': ['Tıp Fakültesi'],
    'Turizm Fakültesi': ['Turizm Fakültesi'],
    'Veteriner Fakültesi': ['Veteriner Fakültesi'],
    'Ziraat Fakültesi': ['Ziraat Fakültesi'],

    'Atatürk İlkeleri ve İnkılâp Tarihi Enstitüsü': ['Atatürk İlkeleri ve İnkılâp Tarihi Enstitüsü'],
    'Eğitim Bilimleri Enstitüsü': ['Eğitim Bilimleri Enstitüsü'],
    'Enstitüler Binası': ['Fen Bilimleri Enstitüsü', 'Sağlık Bilimleri Enstitüsü', 'Sosyal Bilimler Enstitüsü'],
    'Güzel Sanatlar Enstitüsü': ['Güzel Sanatlar Enstitüsü'],
    'Kış Sporları ve Spor Bilimleri Enstitüsü': ['Kış Sporları ve Spor Bilimleri Enstitüsü'],
  
    'Araştırma Merkezleri Binası': [
      'ATAILE Uluslararası Dil Sınaavları Koordinatörlüğü',
      'Akupunktur ve Tamamlayıcı Tıp Yöntemleri Uygulama ve Araştırma Merkezi',
      'Araştırma Metodolojisi Eğitim ve Uygulama Ofisi',
      'Araştırma Üniversitesi Akıllı Yenilikçi Malzeme Odak Alanı Koordinatörlüğü',
      'Araştırma Üniversitesi Eğitim Odak Alanı Koordinatörlüğü',
      'Araştırma Üniversitesi Gıda Arz Güvenliği Sektör Alanı Koordinatörlüğü',
      'Araştırma Üniversitesi İktisat Odak Alanı Koordinatörlüğü',
      'Araştırma Üniversitesi Kimya Sektör Alanı Koordinatörlüğü',
      'Araştırma Üniversitesi Klinik Araştırmalar - Aşı Odak Alanı Koordinatörlüğü',
      'Araştırma Üniversitesi Uzay Bilimleri ve Uydu Teknolojileri Odak Alanı',
      'Araştırma Üniversitesi Yapay Zeka Teknolojileri Odak Alanı Koordinatörlüğü',
      'Akademik Yazım Destek Ofisi',
      'Astrofizik Araştırma ve Uygulama Merkezi',
      'Aşı Geliştirme Uygulama ve Araştırma Merkezi',
      'Avrasya İpekyolu Üniversiteleri Uygulama ve Araştırma Merkezi',
      'Bilgisayar Bilimleri Araştırma ve Uygulama Merkezi',
      'Bilimsel Dergiler Koordinatörlüğü',
      'Bitkisel Üretim Uygulama ve Araştırma Merkezi',
      'Biyoçeşitlilik Uygulama ve Araştırma Merkezi',
      'Çevre Sorunları Uygulama ve Araştırma Merkezi',
      'Çocuk ve Bilim Eğitimi Uygulama ve Araştırma Merkezi',
      'Çoklu Yetenek Tarama ve Yönlendirme Uygulama ve Araştırma Merkezi',
      'Deprem Araştırma Merkezi',
      'Doğu Anadolu Kentsel Projeler Uygulama ve Araştırma Merkezi Müdürlüğü',
      'Doğu Anadolu Yüksek Teknoloji Uygulama ve Araştırma Merkezi Müdürlüğü',
      'Engelli Öğrenci Birimi',
      'Engelli, Yaşlı ve Gazi Araştırma ve Mükemmeliyet Uygulama ve Araştırma Merkezi',
      'Finans Uygulama ve Araştırma Merkezi',
      'Gıda ve Hayvancılık Uygulama ve Araştırma Merkezi',
      'Halı Kilim ve El Sanatları Uygulama ve Araştırma Merkezi',
      'İnsan Hakları ve Şiddetle Mücadele Bilincini Güçlendirme Uygulama ve Araştırma Merkezi',
      'İnsani Değerler Eğitimi Uygulama ve Araştırma Merkezi',
      'İş Sağlığı ve İş Güvenliği Uygulama ve Araştırma Merkezi',
      'Kadın Sorunları Uygulama ve Araştırma Merkezi',
      'Katı ve Tehlikeli Atık Yönetimi Koordinatörlüğü',
      'Klinik Araştırma, Geliştirme ve Tasarım Uygulama ve Araştırma Merkezi',
      'Kudüs Çalışmaları Uygulama ve Araştırma Merkezi',
      'Moda ve Tekstil Tasarım Eğitim Uygulama ve Araştırma Merkezi',
      'Nano Bilim ve Nano Mühendislik Araştırma ve Uygulama Merkezi',
      'Organ Nakli Eğitim Araştırma ve Uygulama Merkezi',
      'Orta Doğu Ve Orta Asya - Kafkaslar Araştırma Ve Uygulama Merkezi',
      'Psikolojik Danışma ve Rehberlik Uygulama ve Araştırma Merkezi',
      'Sağlık Araştırma ve Uygulama Merkezi',
      'Spor Bilimleri Uygulama ve Araştırma Merkezi',
      'Sürekli Eğitim Uygulama ve Araştırma Merkezi',
      'Tarımsal Biyoteknoloji Laboratuvarları Koordinatörlüğü',
      'Tıbbi Aromatik Bitki ve İlaç Araştırma Merkezi',
      'Tıbbi Deneysel Uygulama ve Araştırma Merkezi',
      'Toplumsal Araştırmalar Uygulama ve Araştırma Merkezi',
      'Toplumsal Duyarlılık Projeleri Uygulama ve Araştırma Merkezi',
      'Türk - Ermeni İlişkileri Araştırma Merkezi',
      'Türkçe Öğretimi Uygulama ve Araştırma Merkezi',
      'Türkiyat Araştırmaları Enstitüsü',
      'Ulaştırma Uygulama ve Araştırma Merkezi',
      'Üstün Yetenekliler Eğitim Uygulama ve Araştırma Merkezi',
      'Veterinerlikte Aşı ve Biyolojik Ürün Geliştirme Uygulama ve Araştırma Merkezi',
      'Yüksek Başarımlı Hesaplama Uygulama Ve Araştırma Merkezi',
    ], 
    
    'Türk Mûsikîsi Devlet Konservatuvarı':[
      'Türk Mûsikîsi Devlet Konservatuvarı'
    ],
    'Yabancı Diller Yüksekokulu':[
      'Yabancı Diller Yüksekokulu',
      'Türkçe Öğretimi Uygulama ve Araştırma Merkezi'
    ],

 'Astrofizik Araştırma ve Uygulama Merkezi':[
       'Astrofizik Araştırma ve Uygulama Merkezi'
    ],
    'Rektörlük Binası': [
      'Araştırma Metodolojisi Eğitim ve Uygulama Ofisi',
      'Arşiv Hizmetleri Koordinatörlüğü',
      'Bilimsel Araştırma Projeleri Koordinasyon Birimi',
      'Büyük Veri Yönetim Ofisi',
      'Döner Sermaye İşletme Müdürlüğü',
      'Eğitim Komisyonu',
      'Genel Sekreterlik',
      'Hukuk Danışmanlığı Ofisi',
      'ÖnLisans ve Lisans Eğitim Koordinatörlüğü',
      'Personel Daire Başkanlığı',
      'Proje Geliştirme ve Koordinasyon Ofisi',
      'Rektörlük',
      'Strateji Geliştirme Daire Başkanlığı',
      'Yazı İşleri Müdürlüğü',
      'YLSY Burs Programı Koordinatörlüğü'
    ],
    
    'BAUM Binası': [
      'Bilgi İşlem Daire Başkanlığı',
      'Bilgisayar Bilimleri Araştırma ve Uygulama Merkezi',
      'Öğretme ve Öğrenmeyi Geliştirme Uygulama ve Araştırma Merkezi'
    ],
    'Biyoçeşitlilik Uygulama ve Araştırma Merkezi': ['Biyoçeşitlilik Uygulama ve Araştırma Merkezi'],
    'Buz Eserler Müzesi Koordinatörlüğü': ['Buz Eserler Müzesi Koordinatörlüğü'],
    'İdari ve Mali İşler Daire Başkanlığı': ['İdari ve Mali İşler Daire Başkanlığı'],
    'Koruma ve Güvenlik Müdürlüğü': ['Koruma ve Güvenlik Müdürlüğü'],
    'Kütüphane Binası': ['Kütüphane ve Dokümantasyon Daire Başkanlığı'],
    'Manej Alanı ve Atçılık Koordinatörlüğü': ['Manej Alanı ve Atçılık Koordinatörlüğü'],
    'Mediko Binası': ['Kariyer Planlama ve Mezun İzleme Uygulama ve Araştırma Merkezi'],
    'Okuma Salonu Binası': ['Yayınevi Koordinatörlüğü'],
    'Öğrenci İşleri Binası': ['Dış İlişkiler Ofisi', 'Öğrenci İşleri Daire Başkanlığı'],
    'Sağlık Araştırma ve Uygulama Merkezi': ['Sağlık Araştırma ve Uygulama Merkezi', 'Üniversite Hastanesi Başhekimliği','Akupunktur ve Tamamlayıcı Tıp Yöntemleri Uygulama ve Araştırma Merkezi'],
    'Sağlık Kültür ve Spor Daire Başkanlığı': ['Sağlık Kültür ve Spor Daire Başkanlığı'],
    'Yapı İşleri ve Teknik Daire Başkanlığı': ['Yapı İşleri ve Teknik Daire Başkanlığı'],
    'Konukevi-1': ['Sosyal Tesisler'],
       
     'Oltu Fakülte Binası': [
      'Oltu Beşeri ve Sosyal Bilimler Fakültesi',
      'Uygulamalı Bilimler Fakültesi'
    ],
    'Oltu Fakülteler Binası': [
      'Oltu Havzası Araştırma ve Uygulama Merkezi'
    ],
    'Oltu Meslek Yüksekokulu': [
      'Oltu Meslek Yüksekokulu'
    ],
    'Oltu MYO İdari Binası': [
      'Oltu MYO İdari Binası'
    ],
    'Aşkale Meslek Yüksekokulu': [
      'Aşkale Meslek Yüksekokulu'
    ],
    'Aşkale Yerleşkesi İdari Binası': [
      'Aşkale Yerleşkesi İdari Binası'
    ],
    'Hınıs Meslek Yüksekokulu': [
      'Hınıs Meslek Yüksekokulu'
    ],
    'Hınıs Yerleşkesi İdari Binası': [
      'Hınıs Yerleşkesi İdari Binası'
    ],
    'İspir Hamza Polat Meslek Yüksekokulu': [
      'İspir Hamza Polat Meslek Yüksekokulu'
    ],
    'İspir Yerleşkesi İdari Binası': [
      'İspir Yerleşkesi İdari Binası'
    ],
    'Horasan Meslek Yüksekokulu': [
      'Horasan Meslek Yüksekokulu'
    ],
    'Horasan Yerleşkesi İdari Binası': [
      'Horasan Yerleşkesi İdari Binası'
    ],
    'Narman Meslek Yüksekokulu': [
      'Narman Meslek Yüksekokulu'
    ],
    'Narman Yerleşkesi İdari Binası': [
      'Narman Yerleşkesi İdari Binası'
    ],
    'Pasinler Meslek Yüksekokulu': [
      'Pasinler Meslek Yüksekokulu'
    ],
    'Pasinler Yerleşkesi İdari Binası': [
      'Pasinler Yerleşkesi İdari Binası'
    ],
    'Tortum Meslek Yüksekokulu': [
      'Tortum Meslek Yüksekokulu'
    ],
    'Tortum Yerleşkesi İdari Binası': [
      'Tortum Yerleşkesi İdari Binası'
    ],
    'Yoncalık Yerleşkesi İdari Binası': [
      'Yoncalık Yerleşkesi İdari Binası'
    ],
    'Ziraat Fakültesi İş Müdürlüğü Binası': [
      'Ziraat Fakültesi İş Müdürlüğü Binası'
    ]
  };
}