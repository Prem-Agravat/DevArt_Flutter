import 'package:devart/common/app_shell.dart';
import 'package:devart/data/local_data.dart';
import 'package:devart/resource/resource.dart';
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? expandedIndex;
  late final List<Map<String, String>> questions;

  @override
  void initState() {
    super.initState();
    questions = LocalData.getFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 3,
      selectedDrawerItem: "Help & Support",
      showCart: true,
      showBottomNav: true,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 32, 15, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Top Questions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ...List.generate(
                      questions.length,
                      (index) => _buildQuestion(index),
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        "Still need help?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text("Send a WhatsApp Message"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF61965D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.mail_outline),
                        label: const Text("Send an Email"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppResources.primaryColor,
                          side: const BorderSide(
                            color: AppResources.primaryColor,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 64,
      color: const Color(0xFFF5E9E5),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Help & Support",
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB66D6D),
                  fontFamily: "serif",
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildQuestion(int index) {
    final question = questions[index];
    final expanded = expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              question["question"]!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
            onTap: () {
              setState(() {
                expandedIndex = expanded ? null : index;
              });
            },
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                question["answer"]!,
                style: const TextStyle(color: Colors.black87, height: 1.5),
              ),
            ),
        ],
      ),
    );
  }
}
