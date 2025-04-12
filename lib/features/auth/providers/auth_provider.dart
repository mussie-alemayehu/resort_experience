import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:resort_experience/core/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';

// --- Configuration ---
const String _baseUrl = Endpoints.baseUrl;
const String _prefsKeyLoggedIn = 'isLoggedIn';

// --- HTTP Helper ---
// (Simplified for auth - add token handling here if logout needs it)
Future<Map<String, dynamic>> _postRequest(
    String endpoint, Map<String, dynamic> body) async {
  final url = Uri.parse('$_baseUrl$endpoint');
  try {
    final response = await http
        .post(
          url,
          body: body,
        )
        .timeout(const Duration(seconds: 15));

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
      String errorMessage = responseBody['message']?.toString() ??
          responseBody['error']?.toString() ??
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
  AuthNotifier(this._ref, this._token) : super(AuthState.unknown) {
    _initialize(); // Check auth status on creation
  }

  String? _token;
  final Ref _ref;
  SharedPreferences? _prefs; // Cache instance

  String? get token {
    return _token;
  }

  void setToken(String? token) {
    _token = token;
  }

  Ref get ref {
    return _ref;
  }

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
        Endpoints.loginUser, // <-- REPLACE with your login endpoint
        {'email': email, 'password': password},
      );

      print(response);

      final token =
          response['access_token'] as String?; // Adjust key based on your API
      if (token != null && token.isNotEmpty) {
        state = AuthState.authenticated;
      } else {
        throw Exception(response['message']?.toString() ??
            'Login failed: Token not received.');
      }
    } catch (e) {
      state = AuthState.error;
      // IMPORTANT: Rethrow so UI can catch it and show specific message

      print(e);

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

      final reg = await _postRequest(
        Endpoints.registerUser, // <-- REPLACE with your register endpoint
        requestBody,
      );

      print(reg);

      final response = await _postRequest(
        Endpoints.loginUser,
        {'email': email, 'password': password},
      );

      // Assumption: Successful registration also returns a token and logs the user in.
      // Adjust if your API requires separate login after registration.
      final token = response['access_token'] as String?; // Adjust key
      if (token != null && token.isNotEmpty) {
        setToken(token);
        state = AuthState.authenticated;
      } else {
        throw Exception(response['message']?.toString() ??
            'Registration failed: Token not received.');
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

    state = AuthState.unauthenticated;
  }
}

// --- Riverpod Provider Definition ---
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref, null);
});
