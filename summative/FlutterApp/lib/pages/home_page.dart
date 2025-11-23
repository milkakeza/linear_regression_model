import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';

class HomePage extends StatefulWidget {
  final String apiBaseUrl;

  const HomePage({Key? key, required this.apiBaseUrl}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  bool _smoker = false;
  String _region = 'northeast';
  bool _loading = false;
  double? _lastPrediction;

  final List<String> regions = [
    'northeast',
    'northwest',
    'southeast',
    'southwest',
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _bmiController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final int age = int.parse(_ageController.text.trim());
    final double bmi = double.parse(_bmiController.text.trim());

    setState(() => _loading = true);

    final url = Uri.parse('${widget.apiBaseUrl}/predict');
    final body = json.encode({
      'age': age,
      'bmi': bmi,
      'smoker': _smoker ? "yes" : "no",
      'region': _region,
    });

    try {
      final resp = await http.post(
        url,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        final prediction = (data['predicted_charges'] as num).toDouble();

        if (!mounted) return;
        setState(() {
          _lastPrediction = prediction;
        });
      } else {
        final data = json.decode(resp.body);
        final msg = data['detail'] ?? "Server error";
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Request failed: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.bgGradientTop, AppTheme.bgGradientBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          title: const Text("Insurance Predictor"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Glass card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.2,
                  ),
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required" : null,
                        decoration: const InputDecoration(
                          labelText: "Age",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _bmiController,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required" : null,
                        decoration: const InputDecoration(
                          labelText: "BMI",
                          prefixIcon: Icon(Icons.monitor_weight),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Smoker", style: TextStyle(fontSize: 16)),
                          Switch(
                            value: _smoker,
                            activeColor: AppTheme.primary,
                            onChanged: (v) => setState(() => _smoker = v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _region,
                        decoration: const InputDecoration(labelText: "Region"),
                        items: regions
                            .map(
                              (r) => DropdownMenuItem(value: r, child: Text(r)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _region = v!),
                      ),

                      const SizedBox(height: 24),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Predict"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              if (_lastPrediction != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Predicted Charges",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _lastPrediction!.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
