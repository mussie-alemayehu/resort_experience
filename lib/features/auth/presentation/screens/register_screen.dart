import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resort_experience/config/theme/app_colors.dart';
import 'package:resort_experience/features/auth/providers/auth_provider.dart';

import '../../../../config/router/app_routes.dart';
// Import your LoginScreen for navigation
// import 'login_screen.dart'; // Assuming it's in the same directory

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final registerLoadingProvider = StateProvider<bool>((ref) => false);
// Provider for password visibility
  final registerPasswordVisibleProvider = StateProvider<bool>((ref) => false);
  final registerConfirmPasswordVisibleProvider =
      StateProvider<bool>((ref) => false);
  final enableAnimationsProvider = StateProvider<bool>((ref) => true);

  Widget animatedWidget(Widget child, Duration delay, Duration duration,
      {required bool enableAnimations,
      double moveYBegin = 0,
      double moveXBegin = 0,
      Offset scaleBegin = const Offset(1, 1)}) {
    if (enableAnimations) {
      return child
          .animate()
          .fadeIn(delay: delay, duration: duration)
          .moveY(begin: moveYBegin)
          .moveX(begin: moveXBegin)
          .scale(begin: scaleBegin);
    } else {
      return child; // Return the widget without animation
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final isLoading = ref.watch(registerLoadingProvider);
    final isPasswordVisible = ref.watch(registerPasswordVisibleProvider);
    final isConfirmPasswordVisible =
        ref.watch(registerConfirmPasswordVisibleProvider);
    final enableAnimations = ref.watch(enableAnimationsProvider);

    // Simple Ethiopia phone number regex (adjust if needed)
    final phoneRegex = RegExp(r'^(?:\+?251|0)?9\d{8}$');
    // Basic password strength regex (example: min 8 chars, 1 letter, 1 number)
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

    void submitRegistration() async {
      ref.read(enableAnimationsProvider.notifier).state = false;
      if (formKey.currentState?.validate() ?? false) {
        ref.read(registerLoadingProvider.notifier).state = true;

        try {
          await ref.read(authProvider.notifier).register(
                email: emailController.text,
                password: passwordController.text,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                phoneNumber: phoneController.text,
              );
          // No navigation needed here - GoRouter redirect will handle it
          context.go(AppRoutes.dashboard);
        } catch (e) {
          // Hide loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Failed: ${e.toString()}')),
          );
        }
        if (context.mounted) {
          ref.read(registerLoadingProvider.notifier).state = false;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        // Using AppBar for a cleaner back navigation
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          // Explicit back button
          icon: Icon(Icons.arrow_back_ios_new,
              color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true, // Allow body to go behind AppBar
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Header Text ---
                const SizedBox(height: 40), // Space below AppBar
                animatedWidget(
                    Text(
                      'Join Kuriftu Experience',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    300.ms,
                    500.ms,
                    enableAnimations: enableAnimations),
                const SizedBox(height: 8),

                animatedWidget(
                    Text(
                      'Fill in the details below to get started.',
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    400.ms,
                    500.ms,
                    enableAnimations: enableAnimations),
                const SizedBox(height: 40),

                // --- First Name Field ---
                _buildTextFormField(
                  context: context,
                  controller: firstNameController,
                  enableAnimations: enableAnimations,
                  hintText: 'First Name',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your first name'
                      : null,
                  delay: 500.ms,
                ),
                const SizedBox(height: 20),

                // --- Last Name Field ---
                _buildTextFormField(
                  context: context,
                  controller: lastNameController,
                  enableAnimations: enableAnimations,
                  hintText: 'Last Name',
                  prefixIcon: Icons.person_outline, // Slightly different icon
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your last name'
                      : null,
                  delay: 600.ms,
                ),
                const SizedBox(height: 20),

                // --- Email Field ---
                _buildTextFormField(
                  context: context,
                  controller: emailController,
                  enableAnimations: enableAnimations,
                  hintText: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  delay: 700.ms,
                ),
                const SizedBox(height: 20),

                // --- Phone Number Field ---
                _buildTextFormField(
                  context: context,
                  controller: phoneController,
                  enableAnimations: enableAnimations,
                  hintText: 'Phone Number (e.g., 09... or +2519...)',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid Ethiopian phone number';
                    }
                    return null;
                  },
                  delay: 800.ms,
                ),
                const SizedBox(height: 20),

                // --- Password Field ---
                _buildTextFormField(
                  context: context,
                  controller: passwordController,
                  enableAnimations: enableAnimations,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create a password';
                    }
                    if (!passwordRegex.hasMatch(value)) {
                      return 'Password must be 8+ chars with letters and numbers';
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
                    onPressed: () {
                      ref.read(enableAnimationsProvider.notifier).state = false;
                      ref.read(registerPasswordVisibleProvider.notifier).state =
                          !isPasswordVisible;
                    },
                  ),
                  delay: 900.ms,
                ),
                const SizedBox(height: 20),

                // --- Confirm Password Field ---
                _buildTextFormField(
                  context: context,
                  controller: confirmPasswordController,
                  enableAnimations: enableAnimations,
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !isConfirmPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      ref
                          .read(registerConfirmPasswordVisibleProvider.notifier)
                          .state = !isConfirmPasswordVisible;

                      ref.read(enableAnimationsProvider.notifier).state = false;
                    },
                  ),
                  delay: 1000.ms,
                ),
                const SizedBox(height: 30),

                // --- Register Button ---
                animatedWidget(
                  ElevatedButton(
                    onPressed: isLoading ? null : submitRegistration,
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      minimumSize: WidgetStateProperty.all(
                          const Size(double.infinity, 50)), // Full width
                      // Use secondary color for registration button? Or keep primary?
                      // backgroundColor: MaterialStateProperty.all(AppColors.secondary),
                      // foregroundColor: MaterialStateProperty.all(AppColors.textDark) // Adjust if using secondary
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color:
                                  Colors.white, // Or adjust based on button bg
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('Register'),
                  ),
                  1100.ms,
                  400.ms,
                  moveYBegin: 20,
                  enableAnimations: enableAnimations,
                ),
                const SizedBox(height: 20),

                // --- Navigation to Login Screen ---
                animatedWidget(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate back to Login Screen
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          context.pushReplacement(AppRoutes.login);
                        },
                        child: Text(
                          'Login Here',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  1200.ms,
                  400.ms,
                  moveYBegin: 20,
                  enableAnimations: enableAnimations,
                ),
                const SizedBox(height: 20), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Using the same helper from LoginScreen for consistency
  // Make sure this helper is accessible, either copied here or extracted
  // to a shared location. For this example, it's copied.
  Widget _buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required Duration delay,
    required bool enableAnimations,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return animatedWidget(
        TextFormField(
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
        ),
        delay,
        500.ms,
        enableAnimations: enableAnimations);
  }
}
