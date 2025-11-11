import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool smsNotifications = false;

  // Category Settings
  bool messagesNotif = true;
  bool priceAlertsNotif = true;
  bool systemNotif = true;
  bool appointmentsNotif = true;
  bool socialNotif = true;
  bool marketingNotif = false;

  // Advanced Settings
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool notificationBadge = true;
  bool lockScreenNotif = true;

  String selectedSound = 'Default';
  String quietHoursStart = '22:00';
  String quietHoursEnd = '08:00';

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
          'Notification Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings
            _buildSectionHeader('General Settings'),
            _buildSwitchTile(
              'Push Notifications',
              'Receive notifications on this device',
              pushNotifications,
              (value) => setState(() => pushNotifications = value),
              Icons.notifications_active,
            ),
            _buildSwitchTile(
              'Email Notifications',
              'Receive notifications via email',
              emailNotifications,
              (value) => setState(() => emailNotifications = value),
              Icons.email,
            ),
            _buildSwitchTile(
              'SMS Notifications',
              'Receive notifications via SMS',
              smsNotifications,
              (value) => setState(() => smsNotifications = value),
              Icons.sms,
            ),

            const SizedBox(height: 24),

            // Category Settings
            _buildSectionHeader('Notification Categories'),
            _buildCategoryTile(
              'Messages',
              'New messages from buyers and sellers',
              messagesNotif,
              (value) => setState(() => messagesNotif = value),
              Icons.message,
              Colors.blue,
            ),
            _buildCategoryTile(
              'Price Alerts',
              'Price drops on saved cars',
              priceAlertsNotif,
              (value) => setState(() => priceAlertsNotif = value),
              Icons.local_offer,
              Colors.orange,
            ),
            _buildCategoryTile(
              'System',
              'System updates and announcements',
              systemNotif,
              (value) => setState(() => systemNotif = value),
              Icons.info,
              Colors.green,
            ),
            _buildCategoryTile(
              'Appointments',
              'Test drive requests and reminders',
              appointmentsNotif,
              (value) => setState(() => appointmentsNotif = value),
              Icons.calendar_today,
              Colors.purple,
            ),
            _buildCategoryTile(
              'Social',
              'Followers, likes, and comments',
              socialNotif,
              (value) => setState(() => socialNotif = value),
              Icons.people,
              Colors.teal,
            ),
            _buildCategoryTile(
              'Marketing',
              'Promotions and special offers',
              marketingNotif,
              (value) => setState(() => marketingNotif = value),
              Icons.campaign,
              Colors.pink,
            ),

            const SizedBox(height: 24),

            // Advanced Settings
            _buildSectionHeader('Advanced Settings'),
            _buildSwitchTile(
              'Sound',
              'Play sound for notifications',
              soundEnabled,
              (value) => setState(() => soundEnabled = value),
              Icons.volume_up,
            ),
            _buildSelectTile(
              'Notification Sound',
              selectedSound,
              Icons.music_note,
              () => _showSoundPicker(),
            ),
            _buildSwitchTile(
              'Vibration',
              'Vibrate for notifications',
              vibrationEnabled,
              (value) => setState(() => vibrationEnabled = value),
              Icons.vibration,
            ),
            _buildSwitchTile(
              'Badge',
              'Show notification count on app icon',
              notificationBadge,
              (value) => setState(() => notificationBadge = value),
              Icons.circle_notifications,
            ),
            _buildSwitchTile(
              'Lock Screen',
              'Show notifications on lock screen',
              lockScreenNotif,
              (value) => setState(() => lockScreenNotif = value),
              Icons.lock,
            ),

            const SizedBox(height: 24),

            // Quiet Hours
            _buildSectionHeader('Quiet Hours'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.nightlight_round,
                        color: Color(0xFFFFB347),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Quiet Hours',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePicker(
                          'From',
                          quietHoursStart,
                          (time) => setState(() => quietHoursStart = time),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimePicker(
                          'To',
                          quietHoursEnd,
                          (time) => setState(() => quietHoursEnd = time),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No notifications during these hours',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB347),
                        foregroundColor: const Color(0xFF1A1A1A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _resetToDefaults,
                    child: const Text(
                      'Reset to Defaults',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFB347),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ),
        activeColor: const Color(0xFFFFB347),
      ),
    );
  }

  Widget _buildCategoryTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 48),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ),
        activeColor: const Color(0xFFFFB347),
      ),
    );
  }

  Widget _buildSelectTile(
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    String label,
    String time,
    Function(String) onChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFFFB347),
                  surface: Color(0xFF2C2C2C),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onChanged(
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSoundPicker() {
    final sounds = ['Default', 'Chime', 'Bell', 'Ding', 'Pop', 'None'];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
              child: const Text(
                'Select Notification Sound',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...sounds.map((sound) {
              return ListTile(
                title: Text(sound, style: const TextStyle(color: Colors.white)),
                trailing: selectedSound == sound
                    ? const Icon(Icons.check, color: Color(0xFFFFB347))
                    : null,
                onTap: () {
                  setState(() {
                    selectedSound = sound;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved'),
        backgroundColor: Color(0xFFFFB347),
      ),
    );
    Navigator.pop(context);
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text(
            'Reset to Defaults',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to reset all notification settings to defaults?',
            style: TextStyle(color: Colors.white),
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
                setState(() {
                  pushNotifications = true;
                  emailNotifications = true;
                  smsNotifications = false;
                  messagesNotif = true;
                  priceAlertsNotif = true;
                  systemNotif = true;
                  appointmentsNotif = true;
                  socialNotif = true;
                  marketingNotif = false;
                  soundEnabled = true;
                  vibrationEnabled = true;
                  notificationBadge = true;
                  lockScreenNotif = true;
                  selectedSound = 'Default';
                  quietHoursStart = '22:00';
                  quietHoursEnd = '08:00';
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset to defaults'),
                    backgroundColor: Color(0xFFFFB347),
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
