
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // If needed for interactions later
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:resort_experience/config/theme/app_colors.dart';
import 'package:resort_experience/config/theme/app_typography.dart';

// Enums for clarity
enum PlanTimePreference { earlyRiser, balanced, nightOwl }

enum PlanActivityIntensity {
  relaxed,
  moderate,
  active
} // Match slider values later

class CreatePlanScreen extends ConsumerStatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  ConsumerState<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends ConsumerState<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form State Variables
  double _budget = 300; // Default budget
  int? _selectedDuration = 1; // Default duration
  PlanTimePreference? _selectedTimePreference =
      PlanTimePreference.balanced; // Default
  double _selectedIntensity = 1.0; // 0=Relaxed, 1=Moderate, 2=Active
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = false; // For submit loading state

  // Text Controllers for Dates
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate:
          DateTime.now().subtract(const Duration(days: 1)), // Allow today
      lastDate: DateTime.now()
          .add(const Duration(days: 365 * 2)), // Allow 2 years in future
      builder: (context, child) {
        // Apply theme to date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary, // Header background
                  onPrimary: Colors.white, // Header text
                  onSurface:
                      Theme.of(context).colorScheme.onSurface, // Body text
                ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary, // Button text
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          // Basic validation: Ensure end date is after start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
            _endDateController.text = '';
          }
        } else {
          _endDate = picked;
          _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
          // Basic validation: Ensure end date is after start date
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = null;
            _startDateController.text = '';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('End date cannot be before start date.'),
                  backgroundColor: AppColors.error),
            );
          }
        }
      });
    }
  }

  void _submitCreatePlan() async {
    // Dismiss keyboard if open
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Optional if using onSaved

      // --- 1. Data Collection ---
      final Map<String, dynamic> planRequestData = {
        'budget': _budget.round(),
        'duration_days': _selectedDuration,
        'time_preference': _selectedTimePreference?.name, // e.g., 'balanced'
        // Map intensity slider value (0,1,2) to descriptive name
        'activity_intensity': _getIntensityName(_selectedIntensity),
        'start_date': _startDate
            ?.toIso8601String()
            .split('T')
            .first, // Format as YYYY-MM-DD
        'end_date': _endDate
            ?.toIso8601String()
            .split('T')
            .first, // Format as YYYY-MM-DD
      };

      print("--- Creating Plan Request ---");
      print(planRequestData);
      print("----------------------------");

      setState(() => _isLoading = true);

      // --- 2. API Integration (Placeholder) ---
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // --- TODO: Replace with actual API Call ---
      // try {
      //   final response = await http.post(
      //     Uri.parse('YOUR_PLAN_GENERATION_API_ENDPOINT'),
      //     headers: {'Content-Type': 'application/json'},
      //     body: jsonEncode(planRequestData),
      //   );
      //
      //   if (response.statusCode == 200 || response.statusCode == 201) {
      //     print("Plan generated successfully: ${response.body}");
      //     ScaffoldMessenger.of(context).showSnackBar(
      //        const SnackBar(content: Text('Your custom plan is being generated!'), backgroundColor: AppColors.success),
      //     );
      //     // Optionally: Parse response, maybe get a plan ID or details
      //     // If the API returns the full plan details, you could add it via the provider:
      //     // final newPlanData = jsonDecode(response.body);
      //     // final newPlan = SuggestionPlan.fromJson(newPlanData); // Assuming SuggestionPlan has fromJson
      //     // ref.read(suggestionPlansProvider.notifier).addPlan(newPlan);
      //
      //     Navigator.of(context).pop(); // Go back after successful request
      //
      //   } else {
      //      throw Exception('Failed to create plan: ${response.statusCode} ${response.body}');
      //   }
      // } catch (e) {
      //   print("API Error: $e");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Error creating plan: $e'), backgroundColor: AppColors.error),
      //   );
      // } finally {
      //    setState(() => _isLoading = false);
      // }
      // --- End TODO ---

      // --- Placeholder Success Flow ---
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Plan request sent successfully (See console)!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3)),
      );
      // Pop after a short delay to show message
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          // Check if the widget is still in the tree
          Navigator.of(context).pop();
        }
      });
      // --- End Placeholder Success ---
    } else {
      // Form is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all required fields correctly.'),
            backgroundColor: AppColors.error),
      );
    }
  }

  String _getIntensityName(double value) {
    if (value < 0.5) return 'relaxed';
    if (value < 1.5) return 'moderate';
    return 'active';
  }

  String _getButtonText() {
    return "Create My ${_selectedDuration ?? 'Custom'} Day Resort Plan";
  }

  String _getSummaryText() {
    return "We'll create a custom plan based on your preferences within your budget of \$${_budget.round()}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Plan'),
        backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.9),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Text(
                "Let's customize your perfect resort experience",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 30),

              // --- Activity Budget ---
              _buildSectionTitle(
                  context, Icons.attach_money_rounded, "Activity Budget"),
              Text(
                  "How much would you like to spend on activities during your stay?"),
              const SizedBox(height: 10),
              Column(
                children: [
                  Slider(
                    value: _budget,
                    min: 50,
                    max: 1000,
                    divisions:
                        19, // (1000 - 50) / 50 = 19 divisions for $50 increments
                    label: "\$${_budget.round()}",
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primary.withOpacity(0.3),
                    onChanged: (value) {
                      setState(() {
                        _budget = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("\$50", style: theme.textTheme.bodySmall),
                        Text("\$${_budget.round()}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold)),
                        Text("\$1000", style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 30),

              // --- Duration ---
              _buildSectionTitle(
                  context, Icons.calendar_today_outlined, "Duration"),
              Text("How many days will you be staying at the resort?"),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [1, 2, 3, 4].map((days) {
                  bool isSelected = _selectedDuration == days;
                  return ChoiceChip(
                    label: Text("$days day${days > 1 ? 's' : ''}"),
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary,
                    checkmarkColor:
                        theme.colorScheme.onPrimary, // Optional: show checkmark
                    showCheckmark: true,
                    backgroundColor:
                        theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withOpacity(0.5),
                            width: 1.5)),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedDuration = days);
                      }
                    },
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 30),

              // --- Preferred Time of Day ---
              _buildSectionTitle(
                  context, Icons.access_time_rounded, "Preferred Time of Day"),
              Text(
                  "Are you an early riser or a night owl? Let us know your schedule preference."),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: PlanTimePreference.values.map((pref) {
                  IconData icon;
                  String label;
                  String subLabel;
                  switch (pref) {
                    case PlanTimePreference.earlyRiser:
                      icon = Icons.wb_sunny_outlined;
                      label = "Early Riser";
                      subLabel = "Morning Activities";
                      break;
                    case PlanTimePreference.balanced:
                      icon = Icons.autorenew;
                      label = "Balanced";
                      subLabel = "Mix of Times";
                      break;
                    case PlanTimePreference.nightOwl:
                      icon = Icons.nightlight_round;
                      label = "Night Owl";
                      subLabel = "Evening Activities";
                      break;
                  }
                  bool isSelected = _selectedTimePreference == pref;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        // Make the whole card tappable
                        onTap: () =>
                            setState(() => _selectedTimePreference = pref),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: 200.ms,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accent.withOpacity(0.15)
                                  : theme.colorScheme.surfaceVariant
                                      .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSelected
                                      ? AppColors.accent
                                      : Colors.transparent,
                                  width: 2.0)),
                          child: Column(
                            children: [
                              Icon(icon,
                                  color: isSelected
                                      ? AppColors.accent
                                      : theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                  size: 28),
                              const SizedBox(height: 8),
                              Text(label,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.accent
                                          : theme.colorScheme.onSurface)),
                              const SizedBox(height: 2),
                              Text(subLabel,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: isSelected
                                          ? AppColors.accent.withOpacity(0.9)
                                          : theme.colorScheme.onSurface
                                              .withOpacity(0.6)),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 30),

              // --- Activity Intensity ---
              _buildSectionTitle(
                  context, Icons.directions_run_rounded, "Activity Intensity"),
              Text("How active do you want your resort experience to be?"),
              const SizedBox(height: 10),
              Column(
                children: [
                  Slider(
                    value: _selectedIntensity,
                    min: 0, // Relaxed
                    max: 2, // Active
                    divisions: 2,
                    label: _getIntensityName(_selectedIntensity)
                        .capitalize(), // Capitalize first letter
                    activeColor: AppColors.secondary, // Use secondary color
                    inactiveColor: AppColors.secondary.withOpacity(0.3),
                    onChanged: (value) {
                      setState(() {
                        _selectedIntensity = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          Icon(Icons.self_improvement,
                              color: _selectedIntensity < 0.5
                                  ? AppColors.secondary
                                  : theme.disabledColor),
                          Text("Relaxed", style: theme.textTheme.bodySmall)
                        ]),
                        Column(children: [
                          Icon(Icons.balance,
                              color: _selectedIntensity >= 0.5 &&
                                      _selectedIntensity < 1.5
                                  ? AppColors.secondary
                                  : theme.disabledColor),
                          Text("Moderate", style: theme.textTheme.bodySmall)
                        ]),
                        Column(children: [
                          Icon(Icons.local_fire_department_outlined,
                              color: _selectedIntensity >= 1.5
                                  ? AppColors.secondary
                                  : theme.disabledColor),
                          Text("Active", style: theme.textTheme.bodySmall)
                        ]),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 30),

              // --- Travel Dates (Optional) ---
              _buildSectionTitle(context, Icons.date_range_outlined,
                  "Travel Dates (Optional)"),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startDateController,
                      readOnly: true, // Make it read-only
                      decoration: InputDecoration(
                        labelText: "Start Date",
                        hintText: "dd/mm/yyyy",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () => _selectDate(context, true),
                          color: AppColors.primary,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor:
                            theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      ),
                      onTap: () =>
                          _selectDate(context, true), // Also trigger on tap
                      // No validator needed as it's optional
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "End Date",
                        hintText: "dd/mm/yyyy",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () => _selectDate(context, false),
                          color: AppColors.primary,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor:
                            theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      ),
                      onTap: () => _selectDate(context, false),
                      // Simple validation: Ensure end date is after start date if both are entered
                      validator: (value) {
                        if (_startDate != null &&
                            _endDate != null &&
                            _endDate!.isBefore(_startDate!)) {
                          return 'End date must be after start date';
                        }
                        return null; // Optional field, no error if empty
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 40),

              // --- Submit Button ---
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.add_circle_outline),
                        label: Text(_getButtonText()),
                        onPressed: _submitCreatePlan,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: AppTypography.lightTextTheme.labelLarge
                              ?.copyWith(
                                  fontSize: 16,
                                  color: Colors.white), // Ensure text is white
                          backgroundColor:
                              AppColors.primary, // Use primary color
                          foregroundColor: Colors.white,
                        ),
                      ),
              ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  _getSummaryText(),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, IconData icon, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// Helper extension for capitalizing strings (optional)
extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return "";
    }
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
