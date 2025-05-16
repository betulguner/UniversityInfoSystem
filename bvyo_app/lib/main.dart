import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // Firebase yapılandırma dosyası
import 'home_page.dart'; // Giriş sonrası yönlendirme sayfası

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase başlatma
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giriş Ekranı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blue[700],
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      print('Giriş denemesi: $email'); // Debug için log

      // Firestore'dan kullanıcı bilgilerini kontrol et
      try {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        print('Firestore sorgu sonucu: ${userSnapshot.docs.length} kullanıcı bulundu'); // Debug için log

        if (userSnapshot.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı.',
          );
        }

        // Firebase Authentication ile giriş yap
        print('Firebase Auth ile giriş deneniyor...'); // Debug için log
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('Giriş başarılı!'); // Debug için log

        // Başarılı giriş durumunda ana sayfaya yönlendir
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } catch (firestoreError) {
        print('Firestore hatası: $firestoreError'); // Debug için log
        throw firestoreError;
      }
    } catch (e) {
      print('Hata oluştu: $e'); // Debug için log
      
      if (mounted) {
        String errorMessage = 'Giriş başarısız';
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'Kullanıcı bulunamadı';
              break;
            case 'wrong-password':
              errorMessage = 'Geçersiz şifre';
              break;
            case 'invalid-email':
              errorMessage = 'Geçersiz e-posta adresi';
              break;
            case 'user-disabled':
              errorMessage = 'Bu hesap devre dışı bırakılmış';
              break;
            case 'too-many-requests':
              errorMessage = 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin';
              break;
            default:
              errorMessage = 'Bir hata oluştu: ${e.message}';
          }
        } else if (e is FirebaseException) {
          errorMessage = 'Firebase hatası: ${e.message}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FE),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Icon(Icons.lock_outline, size: 80, color: Colors.blue[700]),
              const SizedBox(height: 24),
              const Text(
                'Hoş Geldiniz',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Giriş Yap', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}