import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ScanRecord {
  final String id;
  final String title;
  final String source;
  final String time;
  final String message;
  final String risk;
  final String category;
  final String reason;
  final String recommendation;

  ScanRecord({
    required this.id,
    required this.title,
    required this.source,
    required this.time,
    required this.message,
    required this.risk,
    required this.category,
    required this.reason,
    required this.recommendation,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'source': source,
        'time': time,
        'message': message,
        'risk': risk,
        'category': category,
        'reason': reason,
        'recommendation': recommendation,
      };

  factory ScanRecord.fromJson(Map<String, dynamic> json) => ScanRecord(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: json['title'] ?? 'Scan Record',
        source: json['source'] ?? 'Manual',
        time: json['time'] ?? 'Just now',
        message: json['message'] ?? '',
        risk: json['risk'] ?? 'Low',
        category: json['category'] ?? 'General',
        reason: json['reason'] ?? '',
        recommendation: json['recommendation'] ?? '',
      );
}

class ScamReportRecord {
  final String id;
  final String category;
  final String source;
  final String message;
  final String url;
  final String details;
  final String timestamp;

  ScamReportRecord({
    required this.id,
    required this.category,
    required this.source,
    required this.message,
    required this.url,
    required this.details,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'source': source,
        'message': message,
        'url': url,
        'details': details,
        'timestamp': timestamp,
      };

  factory ScamReportRecord.fromJson(Map<String, dynamic> json) => ScamReportRecord(
        id: json['id'] ?? '',
        category: json['category'] ?? 'Other',
        source: json['source'] ?? 'SMS',
        message: json['message'] ?? '',
        url: json['url'] ?? '',
        details: json['details'] ?? '',
        timestamp: json['timestamp'] ?? '',
      );
}

class ScamService {
  static final ScamService instance = ScamService._internal();
  ScamService._internal();

  static const MethodChannel _channel = MethodChannel('scamshield/notifications');

  static const String _keyScanHistory = 'scamshield_scan_history';
  static const String _keyReports = 'scamshield_reports';
  static const String _keyAppLanguage = 'scamshield_language';
  static const String _keyVibration = 'scamshield_vibration';
  static const String _keySpringBootUrl = 'scamshield_spring_boot_url';
  static const String _keyOllamaUrl = 'scamshield_ollama_url';

  // Check Android Notification Listener permission
  Future<bool> isNotificationPermissionGranted() async {
    try {
      final bool? granted = await _channel.invokeMethod<bool>('isNotificationPermissionGranted');
      return granted ?? false;
    } catch (_) {
      return false;
    }
  }

  // Open Android Notification Access Settings
  Future<bool> openNotificationAccessSettings() async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('openNotificationAccessSettings');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  // Trigger Device Vibration
  Future<void> triggerVibration({int durationMs = 400}) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_keyVibration) ?? true;
    if (!enabled) return;

    try {
      await _channel.invokeMethod('triggerVibration', {'durationMs': durationMs});
    } catch (_) {
      HapticFeedback.vibrate();
    }
  }

  // Persistent History
  Future<List<ScanRecord>> getScanHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyScanHistory);
    if (raw == null || raw.isEmpty) return [];
    try {
      return raw.map((e) => ScanRecord.fromJson(jsonDecode(e))).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveScanRecord(ScanRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getScanHistory();
    list.insert(0, record);
    final jsonList = list.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_keyScanHistory, jsonList);
  }

  Future<void> clearScanHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyScanHistory);
  }

  // Persistent Reports
  Future<List<ScamReportRecord>> getReports() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyReports);
    if (raw == null || raw.isEmpty) return [];
    try {
      return raw.map((e) => ScamReportRecord.fromJson(jsonDecode(e))).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> submitReport(ScamReportRecord report) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getReports();
    list.insert(0, report);
    final jsonList = list.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_keyReports, jsonList);
  }

  // Language Preference
  Future<String> getAppLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAppLanguage) ?? 'Hindi';
  }

  Future<void> setAppLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAppLanguage, lang);
  }

  // Vibration Setting
  Future<bool> isVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyVibration) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyVibration, enabled);
  }

  // Backend URLs
  Future<String> getSpringBootUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySpringBootUrl) ?? 'http://10.0.2.2:8080/api/analyze';
  }

  Future<void> setSpringBootUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySpringBootUrl, url);
  }

  Future<String> getOllamaUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOllamaUrl) ?? 'http://localhost:11434/api/generate';
  }

  Future<void> setOllamaUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOllamaUrl, url);
  }

  // Hybrid Message Analysis (Spring Boot / Ollama API + Offline Local Rules Engine)
  Future<ScanRecord> analyzeMessage(String message, String language) async {
    // 1. Attempt Spring Boot API if reachable
    try {
      final springUrl = await getSpringBootUrl();
      final response = await http.post(
        Uri.parse(springUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message, 'language': language}),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final record = ScanRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: data['title'] ?? 'Remote AI Assessment',
          source: 'Spring Boot AI',
          time: 'Just now',
          message: message,
          risk: data['risk'] ?? 'High',
          category: data['category'] ?? 'AI Analysis',
          reason: data['reason'] ?? 'Analyzed by Spring Boot Security Gateway.',
          recommendation: data['recommendation'] ?? 'Verify through official channels.',
        );
        await saveScanRecord(record);
        if (record.risk == 'High' || record.risk == 'Medium') {
          await triggerVibration();
        }
        return record;
      }
    } catch (_) {
      // Fallback if server is not connected
    }

    // 2. Local Comprehensive Rule & Threat Intelligence Engine
    final lower = message.toLowerCase();
    String risk = 'Low';
    String title = 'No Immediate Threat Detected';
    String category = 'General Message';
    String reason = 'No common fraud or scam patterns were detected in this message.';
    String recommendation = 'Always exercise normal caution. Do not share sensitive passwords or OTPs.';

    // Rule 1: Banking & KYC Blocking Scams
    if (RegExp(r'(kyc|account.*block|suspend|deactivate|bank.*verify|update.*pancard|yono)').hasMatch(lower)) {
      risk = 'High';
      title = 'Banking / KYC Fraud Threat';
      category = 'Banking Scam';
      reason = 'The message creates panic regarding account suspension/blocking and asks for KYC verification or updates.';
      recommendation = 'Do NOT click links or call numbers in this SMS. Contact your bank directly via their official app or website.';
    }
    // Rule 2: UPI PIN / Payment Scams
    else if (RegExp(r'(receive.*money.*pin|enter.*upi.*pin|claim.*cashback|refund.*credit|scan.*qr.*receive)').hasMatch(lower)) {
      risk = 'High';
      title = 'UPI PIN Fraud Attempt';
      category = 'UPI Scam';
      reason = 'Receiving money NEVER requires entering your UPI PIN. Entering a PIN will deduct funds from your account.';
      recommendation = 'NEVER enter your UPI PIN to receive money. Disconnect immediately.';
    }
    // Rule 3: Prize / Lottery Scams
    else if (RegExp(r'(won|prize|lottery|lucky.*draw|kbc|congratulations.*claim|selected.*reward)').hasMatch(lower)) {
      risk = 'High';
      title = 'Unexpected Reward / Lottery Scam';
      category = 'Prize Fraud';
      reason = 'Unsolicited prize claims asking to open links or pay processing fees are classic lottery fraud schemes.';
      recommendation = 'Ignore unexpected prize messages. Never pay fee or GST to claim an unexpected gift.';
    }
    // Rule 4: Job Offer Scams
    else if (RegExp(r'(part.*time.*job|work.*from.*home|daily.*income|telegram.*task|like.*youtube|guaranteed.*earning)').hasMatch(lower)) {
      risk = 'Medium';
      title = 'Suspicious Job / Task Scheme';
      category = 'Job Scam';
      reason = 'Promises of easy daily income or paid Telegram tasks are frequent pretexts for prepaid task fraud.';
      recommendation = 'Avoid job offers requiring upfront payments, task recharges, or communication over unverified channels.';
    }
    // Rule 5: Delivery / Parcel Scams
    else if (RegExp(r'(parcel.*on.*hold|address.*incomplete|courier.*fee|delivery.*failed|speedpost)').hasMatch(lower)) {
      risk = 'Medium';
      title = 'Unverified Delivery Fee Request';
      category = 'Parcel Scam';
      reason = 'Fake delivery update messages lure users to phishing sites to enter card details for nominal re-delivery fees.';
      recommendation = 'Verify consignment tracking only on the official courier website (e.g. India Post, BlueDart).';
    }
    // Rule 6: Phishing Links & Shortened URLs
    else if (RegExp(r'(http://|https://|bit\.ly|tinyurl|t\.co|is\.gd|cutt\.ly|shorturl)').hasMatch(lower)) {
      if (risk == 'Low') {
        risk = 'Medium';
        title = 'Contains Unverified Link';
        category = 'Link Caution';
        reason = 'The message contains an embedded or shortened URL that obscures the true destination.';
        recommendation = 'Use the Link Checker feature to analyze the URL structure before tapping it.';
      }
    }

    final record = ScanRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      source: 'Manual Message Checker',
      time: 'Just now',
      message: message,
      risk: risk,
      category: category,
      reason: reason,
      recommendation: recommendation,
    );

    await saveScanRecord(record);

    if (risk == 'High' || risk == 'Medium') {
      await triggerVibration();
    }

    return record;
  }
}
