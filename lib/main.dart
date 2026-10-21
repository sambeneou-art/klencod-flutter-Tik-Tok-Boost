// language: Dart, file: main.dart, target: Android / Flutter
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const TikTokBoosterApp());
}

class TikTokBoosterApp extends StatelessWidget {
  const TikTokBoosterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Booster Pro',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      ),
      home: const BoosterHomePage(),
    );
  }
}

class BoosterHomePage extends StatefulWidget {
  const BoosterHomePage({Key? key}) : super(key: key);

  @override
  State<BoosterHomePage> createState() => _BoosterHomePageState();
}

class _BoosterHomePageState extends State<BoosterHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  String _selectedService = 'المتابعين (Followers)';
  int _selectedAmount = 1000;
  bool _isLoading = false;
  double _progressValue = 0.0;
  String _statusMessage = '';

  final List<String> _services = [
    'المتابعين (Followers)',
    'الإعجابات (Likes)',
    'المشاهدات (Views)'
  ];

  final List<int> _amounts = [500, 1000, 5000, 10000];

  void _startBoosting() {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أدخل اسم المستخدم (Username) أولاً يا خويا!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _progressValue = 0.0;
      _statusMessage = 'جاري الاتصال بالسيرفر...';
    });

    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      setState(() {
        _progressValue += 0.02;
        if (_progressValue >= 0.3 && _progressValue < 0.6) {
          _statusMessage = 'جاري التحقق من الحساب و تجاوز الحماية...';
        } else if (_progressValue >= 0.6 && _progressValue < 0.9) {
          _statusMessage = 'جاري حقن الطلب للحساب: @$username...';
        } else if (_progressValue >= 0.9) {
          _statusMessage = 'تمت العملية بنجاح وإرسال الدفعة!';
        }

        if (_progressValue >= 1.0) {
          timer.cancel();
          _isLoading = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TikTok Booster DZ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F1F1F),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'أدخل اسم حسابك على تيك توك',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                prefixText: '@',
                hintText: 'username',
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'اختر الخدمة المطلوبة',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedService,
                  isExpanded: true,
                  items: _services.map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedService = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'اختر الكمية',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedAmount,
                  isExpanded: true,
                  items: _amounts.map((int amount) {
                    return DropdownMenuItem<int>(
                      value: amount,
                      child: Text('$amount وحدة'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedAmount = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _startBoosting,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleButton(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'بدء العملية الآن',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            if (_isLoading || _progressValue > 0) ...[
              LinearProgressIndicator(
                value: _progressValue,
                backgroundColor: Colors.grey[800],
                color: Colors.pinkAccent,
                minHeight: 8,
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(fontSize: 14, color: Colors.pinkAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}