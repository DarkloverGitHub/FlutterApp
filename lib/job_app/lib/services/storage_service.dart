import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _savedJobsKey = 'saved_jobs';
  static const String _appliedJobsKey = 'applied_jobs';
  static const String _darkModeKey = 'dark_mode';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _locationKey = 'location_enabled';

  // ─── Auth ────────────────────────────────────────────────────────────────

  static Future<void> saveUser({
    required String email,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey) ?? '';
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey) ?? 'Guest';
  }

  // ─── Saved Jobs ──────────────────────────────────────────────────────────

  static Future<List<String>> getSavedJobIds() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_savedJobsKey);
    if (data == null) return [];
    return List<String>.from(jsonDecode(data));
  }

  static Future<void> toggleSavedJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = await getSavedJobIds();
    if (saved.contains(jobId)) {
      saved.remove(jobId);
    } else {
      saved.add(jobId);
    }
    await prefs.setString(_savedJobsKey, jsonEncode(saved));
  }

  static Future<bool> isJobSaved(String jobId) async {
    final saved = await getSavedJobIds();
    return saved.contains(jobId);
  }

  // ─── Applied Jobs ────────────────────────────────────────────────────────

  static Future<List<String>> getAppliedJobIds() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_appliedJobsKey);
    if (data == null) return [];
    return List<String>.from(jsonDecode(data));
  }

  static Future<void> applyForJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> applied = await getAppliedJobIds();
    if (!applied.contains(jobId)) {
      applied.add(jobId);
      await prefs.setString(_appliedJobsKey, jsonEncode(applied));
    }
  }

  static Future<bool> hasApplied(String jobId) async {
    final applied = await getAppliedJobIds();
    return applied.contains(jobId);
  }

  // ─── Settings ────────────────────────────────────────────────────────────

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  static Future<bool> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  static Future<void> setNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }

  static Future<bool> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationKey) ?? false;
  }

  static Future<void> setLocation(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationKey, value);
  }
}
