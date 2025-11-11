import 'package:flutter/material.dart';

class PriceAlertSetup extends StatefulWidget {
  final String carName;

  const PriceAlertSetup({super.key, required this.carName});

  @override
  State<PriceAlertSetup> createState() => _PriceAlertSetupState();
}

class _PriceAlertSetupState extends State<PriceAlertSetup> {
  final TextEditingController _targetPriceController = TextEditingController();
  String selectedAlertType = 'Below';
  bool notifyByEmail = true;
  bool notifyByPush = true;

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
          'Set Price Alert',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.directions_car,
                    color: Color(0xFFFFB347),
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.carName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Alert Type
            const Text(
              'Alert When Price:',
              style: TextStyle(
                color: Color(0xFFFFB347),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAlertTypeButton('Below', Icons.trending_down),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAlertTypeButton('Above', Icons.trending_up),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Target Price
            const Text(
              'Target Price (PKR)',
              style: TextStyle(
                color: Color(0xFFFFB347),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _targetPriceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 24),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.attach_money,
                  color: Color(0xFFFFB347),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Notification Settings
            const Text(
              'Notify Me By:',
              style: TextStyle(
                color: Color(0xFFFFB347),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: notifyByPush,
                    onChanged: (value) => setState(() => notifyByPush = value),
                    title: const Row(
                      children: [
                        Icon(Icons.notifications, color: Colors.white70),
                        SizedBox(width: 12),
                        Text(
                          'Push Notification',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    activeColor: const Color(0xFFFFB347),
                  ),
                  Divider(height: 1, color: Colors.white.withOpacity(0.1)),
                  SwitchListTile(
                    value: notifyByEmail,
                    onChanged: (value) => setState(() => notifyByEmail = value),
                    title: const Row(
                      children: [
                        Icon(Icons.email, color: Colors.white70),
                        SizedBox(width: 12),
                        Text('Email', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    activeColor: const Color(0xFFFFB347),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You\'ll receive a notification when the price changes according to your alert settings.',
                      style: TextStyle(
                        color: Colors.blue.shade300,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Create Alert Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createAlert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB347),
                  foregroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Alert',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTypeButton(String type, IconData icon) {
    final isSelected = selectedAlertType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedAlertType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFB347) : const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFB347)
                : Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createAlert() {
    if (_targetPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a target price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Text(
                'Alert Created!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'You\'ll be notified when the price of ${widget.carName} goes $selectedAlertType PKR ${_targetPriceController.text}',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB347),
                foregroundColor: const Color(0xFF1A1A1A),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _targetPriceController.dispose();
    super.dispose();
  }
}
