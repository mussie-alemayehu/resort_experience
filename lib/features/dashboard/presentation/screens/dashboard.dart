import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:resort_experience/core/config/theme/app_colors.dart'; // Your App Colors
import 'package:resort_experience/core/config/router/app_routes.dart'; // Your Routes

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenSize = MediaQuery.of(context).size;

    // Define delays for staggered animations
    final baseDelay = 200.ms;
    final cardDelayIncrement = 150.ms;

    return Scaffold(
      // Use CustomScrollView for sliver effects
      body: CustomScrollView(
        slivers: [
          // --- AppBar ---
          SliverAppBar(
            expandedHeight: screenSize.height * 0.25, // Responsive height
            pinned: true, // Keep visible while scrolling up
            floating: false, // Doesn't immediately reappear on scroll down
            snap: false, // Doesn't snap into view
            elevation: 2.0,
            backgroundColor:
                theme.scaffoldBackgroundColor, // Blends when collapsed
            surfaceTintColor:
                theme.colorScheme.surface, // Material 3 tint color
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              centerTitle: false,
              title: Text(
                'Kuriftu Resort',
                style: textTheme.headlineSmall?.copyWith(
                    // Ensure text color contrasts well when collapsed
                    color: theme.colorScheme.onSurface, // Adjust if needed
                    fontWeight: FontWeight.bold),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              background: Container(
                decoration: BoxDecoration(
                  // Use a subtle gradient matching your theme
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.8),
                      AppColors.accent
                          .withValues(alpha: 0.6), // Blend primary and accent
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                // Optional: Add a subtle background image or pattern here
                // child: Image.asset( 'assets/images/resort_background.png', fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(.3),),
              ).animate().fadeIn(duration: 600.ms),
            ),
          ),

          // --- Welcome Message ---
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 12.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Kuriftu!', // Or "Welcome, [User Name]!" if available
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: baseDelay, duration: 500.ms)
                      .slideX(begin: -0.1, curve: Curves.easeOut),
                  const SizedBox(height: 6),
                  Text(
                    'Your personalized resort experience awaits.',
                    style: textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: baseDelay + 100.ms, duration: 500.ms)
                      .slideX(begin: -0.1, curve: Curves.easeOut),
                ],
              ),
            ),
          ),

          // --- Action Cards ---
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildDashboardCard(
                    context: context,
                    icon: Icons.tune_rounded, // Preferences icon
                    title: 'Your Preferences',
                    subtitle:
                        'Tailor activities and suggestions to your taste.',
                    buttonLabel: 'Set Preferences',
                    color: AppColors.secondary, // Use theme colors
                    onTap: () => context.push(AppRoutes.preferencesIntro),
                    animationDelay: baseDelay + (cardDelayIncrement * 1),
                  ),
                  _buildDashboardCard(
                    context: context,
                    icon: Icons.explore_rounded, // Suggestions icon
                    title: 'Daily Suggestions',
                    subtitle:
                        'Discover curated itineraries for your perfect day.',
                    buttonLabel: 'View Suggestions',
                    color: AppColors.primary, // Use theme colors
                    onTap: () => context.push(AppRoutes.suggestionPlans),
                    animationDelay: baseDelay + (cardDelayIncrement * 2),
                  ),
                  _buildDashboardCard(
                    context: context,
                    icon: Icons.room_service_rounded, // Services icon
                    title: 'Resort Services',
                    subtitle: 'Explore dining, spa, activities, and more.',
                    buttonLabel: 'Explore Services',
                    color: AppColors.accent, // Use theme colors
                    onTap: () => context.push(AppRoutes.services),
                    animationDelay: baseDelay + (cardDelayIncrement * 3),
                  ),
                  // --- Logout Button (Example) ---
                  // Add this if you don't have it elsewhere and want it here
                  /*
                   _buildDashboardCard(
                    context: context,
                    icon: Icons.logout_rounded,
                    title: 'Account',
                    subtitle: 'Manage your profile or sign out.',
                    buttonLabel: 'Logout',
                    color: Colors.grey.shade600, // Neutral color
                    onTap: () async {
                      // Assuming you have access to ref if this were a ConsumerWidget
                      // await ref.read(authProvider.notifier).logout();
                      // GoRouter redirect will handle navigation
                      print("Logout Tapped"); // Placeholder
                    },
                    animationDelay: baseDelay + (cardDelayIncrement * 4),
                  ),
                  */
                ],
              ),
            ),
          ),

          // Add some bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // Helper Widget for Dashboard Action Cards
  Widget _buildDashboardCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required Color color, // Base color for the card accents/button
    required VoidCallback onTap,
    required Duration animationDelay,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bool isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      elevation: 4.0,
      shadowColor: color.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: theme.cardColor, // Use theme card color
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap, // Use onTap for the whole card or just the button
        splashColor: color.withValues(alpha: 0.1),
        highlightColor: color.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // --- Icon ---
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withValues(alpha: isDark ? 0.3 : 0.15),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 20),
              // --- Text & Button ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // --- Button (Optional - could make whole card tappable) ---
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: onTap,
                        style: TextButton.styleFrom(
                            foregroundColor: color,
                            // backgroundColor: color.withValues(alpha: 0.1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6)),
                        child: Text(
                          buttonLabel,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: animationDelay)
        .fadeIn(duration: 500.ms)
        .moveY(begin: 20, curve: Curves.easeOut); // Slide up effect
  }
}
