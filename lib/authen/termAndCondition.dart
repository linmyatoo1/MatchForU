import 'package:flutter/material.dart';
import 'package:match_for_u/authen/registration.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isCheckedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isScrollableToEndNotifier =
      ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkIfScrolledToBottom);
  }

  void _checkIfScrolledToBottom() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _isScrollableToEndNotifier.value = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isCheckedNotifier.dispose();
    _isScrollableToEndNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Terms and Conditions",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _termsText,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Wrap Checkbox inside ValueListenableBuilder
            ValueListenableBuilder<bool>(
              valueListenable: _isScrollableToEndNotifier,
              builder: (context, isScrollableToEnd, child) {
                return ValueListenableBuilder<bool>(
                  valueListenable: _isCheckedNotifier,
                  builder: (context, isChecked, child) {
                    return Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.pinkAccent,
                          activeColor: Colors.white,
                          hoverColor: Colors.black,
                          value: isChecked,
                          onChanged: isScrollableToEnd
                              ? (bool? value) {
                                  _isCheckedNotifier.value = value ?? false;
                                }
                              : null,
                        ),
                        const Expanded(
                          child: Text(
                            "I agree to the Terms and Conditions",
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 10),

            // Next button controlled by ValueListenableBuilder
            SizedBox(
              width: double.infinity,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isCheckedNotifier,
                builder: (context, isChecked, child) {
                  return ElevatedButton(
                    onPressed: isChecked
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registration()),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isChecked ? Colors.pinkAccent : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: isChecked ? 5 : 0,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _termsText = """
1. **Eligibility**
   - You must be at least 18 years old to use this app.
   - You must comply with all local laws and regulations regarding online dating.
   - You must not be legally prohibited from using dating services.

2. **Account Registration & Security**
   - Provide accurate and truthful information.
   - Do not share your account credentials with others.
   - You are responsible for any activity that occurs under your account.
   - We reserve the right to suspend accounts with false or misleading information.

3. **User Conduct & Community Guidelines**
   - Be respectful towards other users.
   - No harassment, hate speech, threats, or fraudulent activity.
   - No spamming or advertising other services.
   - Users must not share or distribute explicit content.

4. **Prohibited Content & Activities**
   - No explicit, violent, or illegal content.
   - No impersonation or misleading profile information.
   - No financial transactions or requests for money from other users.
   - No promotion of escort services or prostitution.

5. **Privacy & Data Protection**
   - Your personal data is protected under our Privacy Policy.
   - We do not sell or share your data without consent.
   - Users are responsible for their own privacy and should exercise caution.

6. **Subscriptions & Payments**
   - Fees are non-refundable unless required by law.
   - Auto-renewal policies apply unless canceled beforehand.
   - Users must provide valid payment information.
   - Refunds are granted only in compliance with our refund policy.

7. **Safety & User Responsibility**
   - Always meet new people in public places first.
   - Never share sensitive or financial information.
   - Users should verify the identity of others before meeting.
   - We are not responsible for any harm or damages resulting from user interactions.

8. **No Background Checks**
   - We do not conduct criminal background checks.
   - Users are responsible for verifying others' information.
   - Any user found engaging in criminal activity will be banned.

9. **Account Termination & Suspension**
   - We may suspend or terminate accounts violating these terms.
   - Users may delete their account at any time.
   - Any user violating terms may be permanently banned.
   - We reserve the right to refuse service to anyone.

10. **Intellectual Property**
    - All app content is owned by [Company Name].
    - Users may not copy or distribute app content without permission.
    - Any unauthorized use of app content may result in legal action.

11. **Third-Party Links & Services**
    - We are not responsible for content on external links.
    - Users interact with third-party services at their own risk.

12. **Limitation of Liability**
    - We do not guarantee successful matches or relationships.
    - We are not liable for damages, disputes, or losses due to app usage.
    - Users agree to hold us harmless from any claims resulting from use.

13. **Changes to Terms & Conditions**
    - We may update these terms at any time.
    - Continued use implies acceptance of updated terms.
    - Users will be notified of major changes where applicable.

14. **Governing Law & Dispute Resolution**
    - Any disputes will be governed by the laws of [Your Country/State].
    - Disputes must first go through mediation before legal action.

15. **Contact Information**
    - For inquiries or support, contact [Support Email/Phone].
    - Users should reach out with any issues before taking legal action.
""";
