import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String selectedLanguage = 'English';

  final List<Map<String, String>> languages = [
    {'name': 'English', 'native': 'English', 'code': 'en'},
    {'name': 'Urdu', 'native': 'اردو', 'code': 'ur'},
    {'name': 'Arabic', 'native': 'العربية', 'code': 'ar'},
    {'name': 'Spanish', 'native': 'Español', 'code': 'es'},
    {'name': 'French', 'native': 'Français', 'code': 'fr'},
    {'name': 'German', 'native': 'Deutsch', 'code': 'de'},
    {'name': 'Italian', 'native': 'Italiano', 'code': 'it'},
    {'name': 'Portuguese', 'native': 'Português', 'code': 'pt'},
    {'name': 'Chinese', 'native': '中文', 'code': 'zh'},
    {'name': 'Japanese', 'native': '日本語', 'code': 'ja'},
    {'name': 'Korean', 'native': '한국어', 'code': 'ko'},
    {'name': 'Russian', 'native': 'Русский', 'code': 'ru'},
    {'name': 'Turkish', 'native': 'Türkçe', 'code': 'tr'},
    {'name': 'Hindi', 'native': 'हिन्दी', 'code': 'hi'},
    {'name': 'Bengali', 'native': 'বাংলা', 'code': 'bn'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Language',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Icon(Icons.language, color: Color(0xFFFFB347), size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Select Your Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your preferred language for the app',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Language List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                final isSelected = selectedLanguage == language['name'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFFB347)
                          : Colors.white.withOpacity(0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFB347).withOpacity(0.2)
                            : Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          language['code']!.toUpperCase(),
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFFFFB347)
                                : Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      language['name']!,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFFFFB347)
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      language['native']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFFFFB347),
                            size: 28,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            color: Colors.white.withOpacity(0.3),
                            size: 28,
                          ),
                    onTap: () {
                      setState(() {
                        selectedLanguage = language['name']!;
                      });
                      _showLanguageChangeDialog(language['name']!);
                    },
                  ),
                );
              },
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _saveLanguagePreference();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB347),
                  foregroundColor: const Color(0xFF1A1A1A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Language',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageChangeDialog(String language) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Language Selected',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'You have selected $language. The app will restart to apply the changes.',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB347),
                foregroundColor: const Color(0xFF1A1A1A),
              ),
              onPressed: () {
                Navigator.pop(context);
                _saveLanguagePreference();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _saveLanguagePreference() {
    // TODO: Implement language preference saving logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to $selectedLanguage'),
        backgroundColor: const Color(0xFFFFB347),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
