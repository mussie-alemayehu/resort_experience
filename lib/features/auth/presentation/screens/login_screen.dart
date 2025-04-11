import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_experience/config/theme/app_colors.dart';

final loginLoadingProvider = StateProvider<bool>((ref) => false);
final loginPasswordVisibleProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final formKey = GlobalKey<FormState>(); // Key for form validation
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isLoading = ref.watch(loginLoadingProvider);
    final isPasswordVisible = ref.watch(loginPasswordVisibleProvider);

    // Dispose controllers when the widget is disposed
    // Note: In simple ConsumerWidgets, direct disposal isn't standard.
    // If state persistence across complex rebuilds is needed, consider
    // ConsumerStatefulWidget or managing controllers via providers.
    // For this basic example, they'll be recreated on rebuilds.

    void submitLogin() {
      if (formKey.currentState?.validate() ?? false) {
        ref.read(loginLoadingProvider.notifier).state = true; // Start loading
        print('Login attempt:');
        print('Email: ${emailController.text}');
        print('Password: ${passwordController.text}');

        // --- TODO: Implement actual login logic here ---
        // Example: Call your authentication service/provider
        // await ref.read(authProvider.notifier).login(email, password);

        // Simulate network call
        Future.delayed(const Duration(seconds: 2), () {
          ref.read(loginLoadingProvider.notifier).state = false; // Stop loading
          // TODO: Navigate on success or show error message
          // Example: Navigator.pushReplacement(...) or showSnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful (Mock)!')),
          );
        });
      } else {
        print('Login form validation failed');
      }
    }

    return Scaffold(
      // Use a gradient or image background for immersive feel if desired
      // backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- App Logo/Title ---
                const Icon(
                  Icons.beach_access_rounded, // Placeholder Icon
                  size: 80,
                  color: AppColors.primary,
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 500.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
                const SizedBox(height: 16),
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 500.ms)
                    .moveY(begin: -10),
                const SizedBox(height: 8),
                Text(
                  'Login to your Kuriftu account',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
                const SizedBox(height: 40),

                // --- Email Field ---
                _buildTextFormField(
                  context: context,
                  controller: emailController,
                  hintText: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Basic email format check
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  delay: 600.ms,
                ),
                const SizedBox(height: 20),

                // --- Password Field ---
                _buildTextFormField(
                  context: context,
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    onPressed: () => ref
                        .read(loginPasswordVisibleProvider.notifier)
                        .state = !isPasswordVisible,
                  ),
                  delay: 700.ms,
                ),
                const SizedBox(height: 25),

                // --- Login Button ---
                ElevatedButton(
                  onPressed: isLoading ? null : submitLogin,
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    minimumSize: WidgetStateProperty.all(
                        const Size(double.infinity, 50)), // Full width
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Login'),
                )
                    .animate(delay: 800.ms)
                    .fadeIn(duration: 400.ms)
                    .moveY(begin: 20),
                const SizedBox(height: 20),

                // --- Forgot Password (Optional) ---
                TextButton(
                  onPressed: () {
                    // TODO: Implement Forgot Password flow
                    print("Navigate to Forgot Password");
                  },
                  child: Text(
                    'Forgot Password?',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: AppColors.secondary),
                  ),
                ).animate(delay: 900.ms).fadeIn(duration: 400.ms),

                // --- Navigation to Register Screen ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Replace with actual navigation
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        // );
                        print("Navigate to Register Screen");
                      },
                      child: Text(
                        'Register Now',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ).animate(delay: 1000.ms).fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for consistent TextFormField styling
  Widget _buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required Duration delay,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: theme.colorScheme.surface
            .withValues(alpha: 0.5), // Slightly transparent
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none, // No border, rely on fill color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      style: theme.textTheme.bodyLarge,
    )
        .animate()
        .fadeIn(delay: delay, duration: 500.ms)
        .moveX(begin: -20, curve: Curves.easeOut);
  }
}
