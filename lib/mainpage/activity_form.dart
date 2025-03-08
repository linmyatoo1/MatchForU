import 'package:flutter/material.dart';
import 'package:match_for_u/models/activity_detail.dart';

class AddActivityForm extends StatefulWidget {
  final VoidCallback onSuccess;

  const AddActivityForm({
    super.key,
    required this.onSuccess,
  });

  @override
  State<AddActivityForm> createState() => _AddActivityFormState();
}

class _AddActivityFormState extends State<AddActivityForm> {
  final _formKey = GlobalKey<FormState>();
  final _activityNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _activityNameController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    try {
      // Show loading state
      setState(() {
        isLoading = true;
      });

      // Create activity data with field names matching the backend expectations
      final activityData = {
        'activityName': _activityNameController.text,
        'time': _timeController.text,
        'location': _locationController.text,
        'number': int.parse(_maxParticipantsController.text),
      };

      // Send to backend
      final success = await ActivityAPI.createActivity(activityData);

      if (success) {
        // Clear the form
        _activityNameController.clear();
        _locationController.clear();
        _timeController.clear();
        _maxParticipantsController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activity created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        widget.onSuccess();

        // Close the form
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create activity. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Activities',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _activityNameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter activity name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an activity name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _locationController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: _timeController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter time (e.g., 18:30)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _maxParticipantsController,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter maximum participants',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the maximum number of participants';
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 1) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Confirm',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
