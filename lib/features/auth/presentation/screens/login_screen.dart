import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resort_experience/core/config/router/app_routes.dart';
import 'package:resort_experience/core/config/theme/app_colors.dart';
import 'package:resort_experience/features/auth/providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final loginLoadingProvider = StateProvider<bool>((ref) => false);
  final loginPasswordVisibleProvider = StateProvider<bool>((ref) => false);
  final enableAnimationsProvider = StateProvider<bool>((ref) => true);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
    final formKey = GlobalKey<FormState>(); // Key for form validation
    final isLoading = ref.watch(loginLoadingProvider);
    final isPasswordVisible = ref.watch(loginPasswordVisibleProvider);
    final enableAnimations = ref.watch(enableAnimationsProvider);

    // Dispose controllers when the widget is disposed
    // Note: In simple ConsumerWidgets, direct disposal isn't standard.
    // If state persistence across complex rebuilds is needed, consider
    // ConsumerStatefulWidget or managing controllers via providers.
    // For this basic example, they'll be recreated on rebuilds.

    void submitLogin() async {
      ref.read(enableAnimationsProvider.notifier).state = false;
      if (formKey.currentState?.validate() ?? false) {
        ref.read(loginLoadingProvider.notifier).state = true; // Start loading

        try {
          await ref.read(authProvider.notifier).login(
                emailController.text,
                passwordController.text,
              );
          context.go(AppRoutes.dashboard);
          // No navigation needed here - GoRouter redirect will handle it upon state change
        } catch (e) {
          // Hide loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Failed: ${e.toString()}')),
          );
        }
        ref.read(loginLoadingProvider.notifier).state = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed.')),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                animatedWidget(
                  const Icon(Icons.beach_access_rounded,
                      size: 80, color: AppColors.primary),
                  300.ms,
                  500.ms,
                  scaleBegin: const Offset(0.8, 0.8),
                  enableAnimations: enableAnimations,
                ),
                const SizedBox(height: 16),
                animatedWidget(
                    Text('Welcome Back',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary)),
                    400.ms,
                    500.ms,
                    enableAnimations: enableAnimations,
                    moveYBegin: -10),
                const SizedBox(height: 8),
                animatedWidget(
                  Text('Login to your Kuriftu account',
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7))),
                  500.ms,
                  500.ms,
                  enableAnimations: enableAnimations,
                ),
                const SizedBox(height: 40),
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
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    enableAnimations: enableAnimations,
                    delay: 600.ms),
                const SizedBox(height: 20),
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
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6)),
                        onPressed: () {
                          ref
                              .read(loginPasswordVisibleProvider.notifier)
                              .state = !isPasswordVisible;

                          ref.read(enableAnimationsProvider.notifier).state =
                              false;
                        }),
                    enableAnimations: enableAnimations,
                    delay: 700.ms),
                const SizedBox(height: 25),
                animatedWidget(
                    ElevatedButton(
                        onPressed: isLoading ? null : submitLogin,
                        style: theme.elevatedButtonTheme.style?.copyWith(
                            minimumSize: WidgetStateProperty.all(
                                const Size(double.infinity, 50))),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5))
                            : const Text('Login')),
                    800.ms,
                    400.ms,
                    enableAnimations: enableAnimations,
                    moveYBegin: 20),
                const SizedBox(height: 20),
                animatedWidget(
                    TextButton(
                        onPressed: () {
                          print("Navigate to Forgot Password");
                        },
                        child: Text('Forgot Password?',
                            style: textTheme.bodyMedium
                                ?.copyWith(color: AppColors.secondary))),
                    900.ms,
                    400.ms,
                    enableAnimations: enableAnimations),
                animatedWidget(
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Don't have an account?",
                          style: textTheme.bodyMedium),
                      TextButton(
                        onPressed: () {
                          context.pushReplacement(AppRoutes.register);
                        },
                        child: Text(
                          'Register Now',
                          style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                    1000.ms,
                    400.ms,
                    enableAnimations: enableAnimations),
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
      enableAnimations: enableAnimations,
      moveXBegin: -20,
    );
  }
}
