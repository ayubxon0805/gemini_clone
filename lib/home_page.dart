import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerateInfoScreen extends StatefulWidget {
  const GenerateInfoScreen({super.key});
  @override
  State<GenerateInfoScreen> createState() => _GenerateInfoScreenState();
}

class _GenerateInfoScreenState extends State<GenerateInfoScreen> {
  String apiKey = "AIzaSyAwKFktctI_EC-O0b8rWUoYBazCxnb6I7o";
  late GenerativeModel model;
  late String responseData;
  late TextEditingController userPromptController;
  late bool isLoading;
  @override
  void initState() {
    super.initState();
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    responseData = "";
    userPromptController = TextEditingController();
    setLoading(false);
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> generateContent(String prompt) async {
    final content = [Content.text(prompt)];
    setLoading(true);
    try {
      final response = await model.generateContent(content);
      if (response.candidates.isNotEmpty) {
        responseData = response.text ?? "";
        setState(() {});
      } else {
        responseData = "No data found!";
      }
    } catch (error) {
      responseData = "Something went wrong!";
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(context),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return Container(
      height: 900,
      decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage('images/macbook.png'),
              fit: BoxFit.cover,
              opacity: 0.4)),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          responseData.isEmpty
                              ? "How Can I help you"
                              : responseData,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 5),
                    child: TextField(
                      cursorErrorColor: Colors.red,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: userPromptController,
                      decoration: InputDecoration(
                        hintText: "Enter your question here!",
                        hintStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w200),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  iconSize: 35,
                  color: const Color.fromARGB(255, 217, 217, 217),
                  onPressed: () {
                    generateContent(userPromptController.text);
                    userPromptController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
