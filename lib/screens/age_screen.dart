import 'package:flutter/material.dart';
import 'gender_screen.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({Key? key}) : super(key: key);

  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  int selectedAge = 21;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How Old Are You?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Be honest!', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: ListWheelScrollView(
                  itemExtent: 50,
                  diameterRatio: 1.5,
                  useMagnifier: true,
                  magnification: 1.3,
                  physics: FixedExtentScrollPhysics(),
                  children: List.generate(13, (index) {
                    final age = 18 + index;
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        '$age',
                        style: TextStyle(
                          fontSize: age == selectedAge ? 24 : 18,
                          fontWeight:
                              age == selectedAge
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                          color: age == selectedAge ? Colors.pink : Colors.grey,
                        ),
                      ),
                    );
                  }),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedAge = 18 + index;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenderScreen(age: selectedAge),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
