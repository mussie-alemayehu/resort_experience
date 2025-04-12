// lib/features/auth/providers/auth_state.dart (example path)
enum AuthState {
  unknown, // Initial state before checking persistence
  unauthenticated, // User is logged out
  authenticating, // Login/Register in progress
  authenticated, // User is logged in
  error, // An error occurred during authentication
}
