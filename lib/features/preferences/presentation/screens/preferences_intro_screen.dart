import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:resort_experience/core/config/theme/app_colors.dart'; // Your theme
import 'package:resort_experience/features/preferences/models/user_preferences.dart';
import 'package:resort_experience/features/preferences/presentation/widgets/selectable_chip.dart';
import 'package:resort_experience/features/preferences/presentation/widgets/step_title.dart';
// Import other widgets if you created them

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final PageController _pageController = PageController();
  final UserPreferences _preferences = UserPreferences();
  int _currentStep = 0;
  final int _totalSteps = 6; // 5 input steps + 1 review step

  // Define options for choices - makes code cleaner
  final List<Map<String, dynamic>> _activityOptions = [
    {'label': 'Adventure', 'icon': Icons.hiking},
    {'label': 'Culinary', 'icon': Icons.restaurant},
    {'label': 'Wellness', 'icon': Icons.spa},
    {'label': 'Sports', 'icon': Icons.sports_soccer}, // Example icons
    {'label': 'Nature', 'icon': Icons.nature_people},
    {'label': 'Cultural', 'icon': Icons.museum},
    {'label': 'Nightlife', 'icon': Icons.nightlife},
  ];

  final List<Map<String, dynamic>> _travelGoalOptions = [
    {'label': 'Trips & Treks', 'icon': Icons.directions_walk},
    {'label': 'Pamper & Socialize', 'icon': Icons.celebration},
    {'label': 'Rejuvenate', 'icon': Icons.self_improvement},
    {'label': 'Seek Adventure', 'icon': Icons.explore},
    {'label': 'Learn Something New', 'icon': Icons.lightbulb_outline},
  ];

  final List<Map<String, dynamic>> _idealDayOptions = [
    {'label': 'Nature walks', 'icon': Icons.park_outlined},
    {'label': 'Lazy mornings', 'icon': Icons.free_breakfast_outlined},
    {'label': 'Beach all day', 'icon': Icons.beach_access},
    {'label': 'Thrilling excursions', 'icon': Icons.directions_run},
    {'label': 'Creative workshops', 'icon': Icons.palette_outlined},
    {'label': 'Stargazing nights', 'icon': Icons.star_border},
  ];

  // Text Editing Controllers for Step 5
  final _mustDoController = TextEditingController();
  final _avoidController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _mustDoController.dispose();
    _avoidController.dispose();
    super.dispose();
  }

  void _nextStep() {
    // Optional: Add validation per step if needed
    // if (!_preferences.isStepComplete(_currentStep)) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please complete the current step.'), duration: Duration(seconds: 1)),
    //   );
    //   return;
    // }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: 400.ms,
        curve: Curves.easeInOutSine,
      );
    } else {
      // Last step action: Submit
      _submitPreferences();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: 400.ms,
        curve: Curves.easeInOutSine,
      );
    }
  }

  void _submitPreferences() async {
    // Update text fields before submitting
    _preferences.mustDoExperiences = _mustDoController.text;
    _preferences.experiencesToAvoid = _avoidController.text;

    final preferencesJson = _preferences.toJson();

    // --- TODO: Implement API Call ---
    // Show loading indicator
    // try {
    //   final response = await http.post(
    //     Uri.parse('YOUR_API_ENDPOINT_HERE'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode(preferencesJson),
    //   );
    //   // Hide loading indicator
    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Preferences saved successfully!'), backgroundColor: AppColors.success),
    //     );
    //     Navigator.of(context).pop(); // Go back or navigate to confirmation
    //   } else {
    //     throw Exception('Failed to save preferences: ${response.body}');
    //   }
    // } catch (e) {
    //   // Hide loading indicator
    //   print("API Error: $e");
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error saving preferences: $e'), backgroundColor: AppColors.error),
    //   );
    // }
    // --- End TODO ---

    // For now, just show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Preferences ready for API call (check console).'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3)),
    );
    // Optionally pop after submission
    // Future.delayed(const Duration(seconds: 1), () => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double progress = (_currentStep + 1) / _totalSteps;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Preferences'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: _previousStep,
              ).animate().fadeIn()
            : null, // Hide back button on first step
        backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.85),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ).animate().fadeIn(delay: 100.ms), // Animate progress bar
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                _buildStep1(context),
                _buildStep2(context),
                _buildStep3(context),
                _buildStep4(context),
                _buildStep5(context),
                _buildReviewStep(context),
              ],
            ),
          ),
          _buildNavigationControls(context),
        ],
      ),
    );
  }

  // ===========================================
  // Step Builder Methods
  // ===========================================

  Widget _buildStep1(BuildContext context) {
    return _buildStepContainer(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepTitle(
              title: "Plan your perfect getaway",
              subtitle: "Step 1 of 5 - Tell us what you love"),
          Text("Which activities interest you?",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10.0,
            runSpacing: 12.0,
            children: _activityOptions.map((option) {
              final label = option['label'] as String;
              return SelectableChip(
                label: label,
                icon: option['icon'] as IconData?,
                isSelected: _preferences.activityInterests.contains(label),
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _preferences.activityInterests.add(label);
                    } else {
                      _preferences.activityInterests.remove(label);
                    }
                  });
                },
              );
            }).toList(),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms)
              .slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    final theme = Theme.of(context);
    return _buildStepContainer(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepTitle(
              title: "Tell us about your experience & goals",
              subtitle: "Step 2 of 5 - A bit about your style"),

          // --- Visited Before ---
          Text("Have you visited a tropical resort before?",
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ChoiceChip(
                label: const Text('Yes'),
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                    color: _preferences.visitedTropicalResort == true
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface),
                selected: _preferences.visitedTropicalResort == true,
                selectedColor: theme.colorScheme.primary,
                checkmarkColor: theme.colorScheme.onPrimary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: _preferences.visitedTropicalResort == true
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.5),
                        width: 1.5)),
                onSelected: (selected) =>
                    setState(() => _preferences.visitedTropicalResort = true),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('No'),
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                    color: _preferences.visitedTropicalResort == false
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface),
                selected: _preferences.visitedTropicalResort == false,
                selectedColor: theme.colorScheme.primary,
                checkmarkColor: theme.colorScheme.onPrimary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: _preferences.visitedTropicalResort == false
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.5),
                        width: 1.5)),
                onSelected: (selected) =>
                    setState(() => _preferences.visitedTropicalResort = false),
              ),
            ],
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 25),

          // --- Travel Goal ---
          Text("What's your main travel goal?",
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10.0,
            runSpacing: 12.0,
            children: _travelGoalOptions.map((option) {
              final label = option['label'] as String;
              return SelectableChip(
                label: label,
                icon: option['icon'] as IconData?,
                isSelected: _preferences.travelGoals.contains(label),
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _preferences.travelGoals.add(label);
                    } else {
                      _preferences.travelGoals.remove(label);
                    }
                  });
                },
              );
            }).toList(),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildStep3(BuildContext context) {
    final theme = Theme.of(context);
    return _buildStepContainer(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepTitle(
              title: "What's your ideal day like?",
              subtitle: "Step 3 of 5 - Pace and activities"),

          // --- Ideal Day Activities ---
          Text("Pick up to 3 options that sound most appealing:",
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10.0,
            runSpacing: 12.0,
            children: _idealDayOptions.map((option) {
              final label = option['label'] as String;
              bool isSelected = _preferences.idealDayActivities.contains(label);
              bool canSelectMore = _preferences.idealDayActivities.length < 3;

              return SelectableChip(
                label: label,
                icon: option['icon'] as IconData?,
                isSelected: isSelected,
                onSelected: (shouldBeSelected) {
                  setState(() {
                    if (shouldBeSelected) {
                      if (canSelectMore) {
                        _preferences.idealDayActivities.add(label);
                      } else {
                        // Optional: Show feedback that limit is reached
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('You can select up to 3 options.'),
                              duration: Duration(seconds: 1)),
                        );
                      }
                    } else {
                      _preferences.idealDayActivities.remove(label);
                    }
                  });
                },
              );
            }).toList(),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

          const SizedBox(height: 25),

          // --- Energy Level ---
          Text("What's your energy level for activities?",
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          // Using ChoiceChips for single selection segmented control look
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: EnergyLevel.values.map((level) {
              String label;
              IconData icon;
              switch (level) {
                case EnergyLevel.slow:
                  label = 'Slow & Steady';
                  icon = Icons.self_improvement;
                  break;
                case EnergyLevel.balanced:
                  label = 'Balanced';
                  icon = Icons.balance;
                  break;
                case EnergyLevel.high:
                  label = 'High-energy';
                  icon = Icons.local_fire_department_outlined;
                  break;
              }
              bool isSelected = _preferences.energyLevel == level;
              return Expanded(
                // Make chips fill space
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0), // Add spacing
                  child: ChoiceChip(
                    label: Row(
                      // Icon and Text
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon,
                            size: 18,
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface),
                        const SizedBox(width: 6),
                        Text(label),
                      ],
                    ),
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary,
                    checkmarkColor:
                        theme.colorScheme.onPrimary, // Hide default checkmark
                    showCheckmark: false,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline
                                    .withValues(alpha: 0.5),
                            width: 1.5)),
                    onSelected: (selected) =>
                        setState(() => _preferences.energyLevel = level),
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildStep4(BuildContext context) {
    final theme = Theme.of(context);
    return _buildStepContainer(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepTitle(
              title: "Who will you be with?",
              subtitle: "Step 4 of 5 - Tell us about your group"),

          // --- Social Preference ---
          Text("How social are you feeling on this trip?",
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          // Using ChoiceChips for single selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: SocialPreference.values.map((pref) {
              String label;
              switch (pref) {
                case SocialPreference.introverted:
                  label = "Introverted";
                  break;
                case SocialPreference.fewNewFaces:
                  label = "A few new faces";
                  break;
                case SocialPreference.meetEveryone:
                  label = "Meet everyone!";
                  break;
              }
              bool isSelected = _preferences.socialPreference == pref;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(label, textAlign: TextAlign.center),
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary,
                    checkmarkColor: theme.colorScheme.onPrimary,
                    showCheckmark: false,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline
                                    .withValues(alpha: 0.5),
                            width: 1.5)),
                    onSelected: (selected) =>
                        setState(() => _preferences.socialPreference = pref),
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 25),

          // --- Travel Companion ---
          Text("Are you traveling with anyone?",
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          // Using Wrap for flexible layout
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: TravelCompanion.values.map((companion) {
              String label;
              IconData icon;
              switch (companion) {
                case TravelCompanion.justMe:
                  label = 'Just Me';
                  icon = Icons.person_outline;
                  break;
                case TravelCompanion.partner:
                  label = 'Partner';
                  icon = Icons.favorite_border;
                  break;
                case TravelCompanion.family:
                  label = 'Family';
                  icon = Icons.family_restroom_outlined;
                  break;
                case TravelCompanion.friends:
                  label = 'Friends';
                  icon = Icons.people_outline;
                  break;
              }
              bool isSelected = _preferences.travelCompanion == companion;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18),
                    const SizedBox(width: 6),
                    Text(label)
                  ],
                ),
                labelStyle: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface),
                selected: isSelected,
                selectedColor: theme.colorScheme.primary,
                checkmarkColor: theme.colorScheme.onPrimary,
                showCheckmark: true,
                backgroundColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.5),
                        width: 1.5)),
                onSelected: (selected) =>
                    setState(() => _preferences.travelCompanion = companion),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              );
            }).toList(),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildStep5(BuildContext context) {
    final theme = Theme.of(context);
    // Ensure controllers have the latest text if user navigates back and forth
    _mustDoController.text = _preferences.mustDoExperiences;
    _avoidController.text = _preferences.experiencesToAvoid;

    return _buildStepContainer(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepTitle(
              title: "Any special wishes?",
              subtitle: "Step 5 of 5 - Help us tailor it perfectly"),

          // --- Must-Do Experiences ---
          Text("Any must-do experiences you're hoping for?",
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          TextFormField(
            controller: _mustDoController,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText:
                  "e.g., Sunrise yoga, traditional coffee ceremony, specific restaurant...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              fillColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              filled: true,
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (value) =>
                _preferences.mustDoExperiences = value, // Update model directly
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 25),

          // --- Experiences to Avoid ---
          Text("Anything you want to avoid? (Optional)",
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          TextFormField(
            controller: _avoidController,
            maxLines: 3,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText:
                  "e.g., Crowded areas, specific foods, early mornings...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              fillColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              filled: true,
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (value) => _preferences.experiencesToAvoid =
                value, // Update model directly
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildReviewStep(BuildContext context) {
    _preferences.mustDoExperiences = _mustDoController.text;
    _preferences.experiencesToAvoid = _avoidController.text;

    return _buildStepContainer(
      context,
      isScrollable: true, // Allow scrolling for review
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepTitle(
              title: "Looking good! Review your preferences",
              subtitle: "Confirm and finalize your choices"),
          _buildReviewSection(
              context,
              "Activities",
              _preferences.activityInterests.join(', '),
              Icons.interests_outlined),
          _buildReviewSection(
              context,
              "Experience",
              "Visited tropical resort before: ${_preferences.visitedTropicalResort == true ? 'Yes' : _preferences.visitedTropicalResort == false ? 'No' : 'N/A'}",
              Icons.travel_explore),
          _buildReviewSection(context, "Travel Goal",
              _preferences.travelGoals.join(', '), Icons.flag_outlined),
          _buildReviewSection(
              context,
              "Ideal Day",
              _preferences.idealDayActivities.join(', '),
              Icons.wb_sunny_outlined),
          _buildReviewSection(
              context,
              "Energy Level",
              _preferences.energyLevel?.name ?? 'N/A', // Use enum name
              Icons.battery_charging_full_outlined),
          _buildReviewSection(
              context,
              "Social Style",
              _preferences.socialPreference?.name ?? 'N/A',
              Icons.people_alt_outlined),
          _buildReviewSection(
              context,
              "Traveling With",
              _preferences.travelCompanion?.name ?? 'N/A',
              Icons.group_outlined),
          _buildReviewSection(
              context,
              "Must-Do Wishes",
              _preferences.mustDoExperiences.isEmpty
                  ? "None specified"
                  : _preferences.mustDoExperiences,
              Icons.star_outline),
          _buildReviewSection(
              context,
              "Things to Avoid",
              _preferences.experiencesToAvoid.isEmpty
                  ? "None specified"
                  : _preferences.experiencesToAvoid,
              Icons.block_outlined),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  // Helper for review sections
  Widget _buildReviewSection(
      BuildContext context, String title, String value, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value.isEmpty ? "Not specified" : value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.8))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================
  // Helper Methods
  // ===========================================

  // Wraps each step's content with padding and scrolling if needed
  Widget _buildStepContainer(BuildContext context,
      {required Widget child, bool isScrollable = false}) {
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: child,
    );

    return isScrollable ? SingleChildScrollView(child: content) : content;
  }

  // Builds the bottom navigation bar (Back/Next/Submit buttons)
  Widget _buildNavigationControls(BuildContext context) {
    final theme = Theme.of(context);
    final bool isLastStep = _currentStep == _totalSteps - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Use surface color for background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
        // Optional: Add top border
        // border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button (Animated)
          AnimatedOpacity(
            opacity: _currentStep > 0 ? 1.0 : 0.0,
            duration: 200.ms,
            child: TextButton.icon(
              icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              label: const Text('Back'),
              onPressed: _currentStep > 0 ? _previousStep : null,
              style: TextButton.styleFrom(
                foregroundColor:
                    theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),

          // Next / Submit Button
          ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              // Use accent color on the final step?
              backgroundColor:
                  isLastStep ? AppColors.success : theme.colorScheme.primary,
              foregroundColor:
                  isLastStep ? Colors.white : theme.colorScheme.onPrimary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isLastStep ? 'Confirm & Submit' : 'Next'),
                const SizedBox(width: 8),
                Icon(
                    isLastStep
                        ? Icons.check_circle_outline
                        : Icons.arrow_forward_ios_rounded,
                    size: 16),
              ],
            ),
          )
              .animate(key: ValueKey(_currentStep)) // Re-animate on step change
              .fadeIn(delay: 100.ms)
              .slideX(begin: 0.2, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
