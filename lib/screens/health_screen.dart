//muhammad qodri (2301010172)

import 'package:flutter/material.dart';
import 'package:klp_mobile3/models/data_health.dart';
import 'package:klp_mobile3/services/service_health.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HealthFormScreen extends StatefulWidget {
  final bool isEditing;
  final HealthData? initialData;

  const HealthFormScreen({
    super.key,
    required this.isEditing,
    this.initialData,
  });

  @override
  _HealthFormScreenState createState() => _HealthFormScreenState();
}

class _HealthFormScreenState extends State<HealthFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final HealthService _healthService = HealthService();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Color darkBlue = const Color(0xFF48CAE4);
  final Color primaryBlue = const Color(0xFF2C405E);
  final Color backgroundColor = const Color(0xFF15202B);
  final Color textColor = const Color(0xFF333333);
  final Color cardColor = Colors.white;

  double weight = 0;
  double height = 0;
  int age = 0;
  String gender = 'Male';
  List<String> healthConditions = [];
  String? _currentDataId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    if (widget.isEditing && widget.initialData != null) {
      _loadInitialData();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final data = widget.initialData!;
    setState(() {
      weight = data.weight;
      height = data.height;
      age = data.age;
      gender = data.gender;
      healthConditions = data.healthConditions;
      _currentDataId = data.id;
    });
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textColor.withOpacity(0.8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryBlue.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryBlue.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
      filled: true,
      fillColor: cardColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryBlue,
        colorScheme: ColorScheme.light(
          primary: primaryBlue,
          secondary: darkBlue,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                widget.isEditing ? 'Edit Health Data' : 'Add Health Data',
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryBlue, darkBlue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.health_and_safety,
                                      color: Colors.white, size: 30),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Please fill in your health information',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _buildAnimatedFormField(
                                    child: TextFormField(
                                      initialValue: widget.isEditing
                                          ? weight.toString()
                                          : null,
                                      decoration: const InputDecoration(
                                        labelText: 'Weight (kg)',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your weight';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        weight = double.parse(value!);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    initialValue: widget.isEditing
                                        ? height.toString()
                                        : null,
                                    decoration: const InputDecoration(
                                      labelText: 'Height (cm)',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your height';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      height = double.parse(value!);
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    initialValue: widget.isEditing
                                        ? age.toString()
                                        : null,
                                    decoration: const InputDecoration(
                                      labelText: 'Age',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your age';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      age = int.parse(value!);
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      labelText: 'Gender',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: gender,
                                    items: ['Male', 'Female']
                                        .map((label) => DropdownMenuItem(
                                              value: label,
                                              child: Text(label),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        gender = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildAnimatedFormField(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 55),
                                backgroundColor: primaryBlue,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )
                                  : Text(
                                      widget.isEditing
                                          ? 'Update Information'
                                          : 'Save Information',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryBlue),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedFormField({required Widget child}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut,
        ),
      ),
      child: child,
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        _formKey.currentState!.save();

        final bmi = weight / ((height / 100) * (height / 100));

        final healthData = HealthData(
          id: widget.isEditing ? _currentDataId! : DateTime.now().toString(),
          userId: 'current_user_id',
          weight: weight,
          height: height,
          age: age,
          gender: gender,
          healthConditions: healthConditions,
          bmi: bmi,
        );

        if (widget.isEditing) {
          await _healthService.updateHealthData(healthData);
        } else {
          await _healthService.createHealthData(healthData);
        }

        Navigator.of(context).pop(true);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving health data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
