import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart'; // Import the enum

// --- Configuration ---
const String _baseUrl = 'https://your-api.com/api';
const String _prefsKeyAuthToken = 'authToken';
const String _prefsKeyLoggedIn = 'isLoggedIn';

// --- HTTP Helper ---
// (Simplified for auth - add token handling here if logout needs it)
Future<Map<String, dynamic>> _postRequest(
    String endpoint, Map<String, dynamic> body) async {
  final url = Uri.parse('$_baseUrl/$endpoint');
  try {
    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body),
        )
        .timeout(const Duration(seconds: 15)); // Add a timeout

    final responseBody = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseBody is Map<String, dynamic>) {
        return responseBody;
      } else {
        // Handle cases where API might return non-map success (e.g., just status)
        // Adapt as needed based on your API behavior
        return {'success': true, 'data': responseBody};
      }
    } else {
      // Try to extract error message from API response
      String errorMessage = responseBody['message'] ??
          responseBody['error'] ??
          'Unknown error occurred';
      throw Exception('API Error (${response.statusCode}): $errorMessage');
    }
  } on TimeoutException {
    throw Exception('Request timed out. Please check your connection.');
  } on http.ClientException catch (e) {
    throw Exception('Network error: Failed to connect to server. ${e.message}');
  } catch (e) {
    throw Exception('An unexpected error occurred: ${e.toString()}');
  }
}

// --- Auth Notifier ---
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._ref) : super(AuthState.unknown) {
    _initialize(); // Check auth status on creation
  }

  final Ref _ref;
  SharedPreferences? _prefs; // Cache instance

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final isLoggedIn = _prefs?.getBool(_prefsKeyLoggedIn) ?? false;
    // Optionally validate token here if needed
    state = isLoggedIn ? AuthState.authenticated : AuthState.unauthenticated;
  }

  Future<void> login(String email, String password) async {
    if (state == AuthState.authenticating) return; // Prevent multiple attempts
    state = AuthState.authenticating;
    try {
      final response = await _postRequest(
        'auth/login', // <-- REPLACE with your login endpoint
        {'email': email, 'password': password},
      );

      final token =
          response['token'] as String?; // Adjust key based on your API
      if (token != null && token.isNotEmpty) {
        await _saveAuthData(token);
        state = AuthState.authenticated;
      } else {
        throw Exception(
            response['message'] ?? 'Login failed: Token not received.');
      }
    } catch (e) {
      state = AuthState.error;
      // IMPORTANT: Rethrow so UI can catch it and show specific message
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    // Add other fields as needed by your API
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    if (state == AuthState.authenticating) return;
    state = AuthState.authenticating;
    try {
      // Build request body dynamically
      final requestBody = {
        'email': email,
        'password': password,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      };

      final response = await _postRequest(
        'auth/register', // <-- REPLACE with your register endpoint
        requestBody,
      );

      // Assumption: Successful registration also returns a token and logs the user in.
      // Adjust if your API requires separate login after registration.
      final token = response['token'] as String?; // Adjust key
      if (token != null && token.isNotEmpty) {
        await _saveAuthData(token);
        state = AuthState.authenticated;
      } else {
        throw Exception(
            response['message'] ?? 'Registration failed: Token not received.');
      }
    } catch (e) {
      state = AuthState.error;
      // IMPORTANT: Rethrow so UI can catch it and show specific message
      rethrow;
    }
  }

  Future<void> logout() async {
    // Optional: Call an API endpoint to invalidate the token on the server
    // try {
    //   await _postRequest('auth/logout', {}); // Assuming a logout endpoint exists
    // } catch (e) {
    //   print("Logout API call failed (non-critical): $e");
    // }

    await _clearAuthData();
    state = AuthState.unauthenticated;
    print("Logout Successful, State: $state"); // For debugging
  }

  // --- Internal Helpers ---
  Future<void> _saveAuthData(String token) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(_prefsKeyAuthToken, token);
    await _prefs?.setBool(_prefsKeyLoggedIn, true);
  }

  Future<void> _clearAuthData() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.remove(_prefsKeyAuthToken);
    await _prefs
        ?.remove(_prefsKeyLoggedIn); // Ensure logged in status is also cleared
  }

  // Optional: Method to get the current token if needed elsewhere
  Future<String?> getToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.getString(_prefsKeyAuthToken);
  }
}

// --- Riverpod Provider Definition ---
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
