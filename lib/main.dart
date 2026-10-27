
import 'package:flutter/material.dart';

void main() {
  runApp(const TanuchiShalaApp());
}

class TanuchiShalaApp extends StatelessWidget {
  const TanuchiShalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'तानुची शाळा',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {
        'title': 'मराठी अक्षरे',
        'emoji': '🔤',
        'color': Colors.pink,
        'lesson': 'letters',
      },
      {
        'title': 'अंकांची दुनिया',
        'emoji': '🔢',
        'color': Colors.blue,
        'lesson': 'numbers',
      },
      {
        'title': 'रंग ओळखा',
        'emoji': '🎨',
        'color': Colors.orange,
        'lesson': 'colors',
      },
      {
        'title': 'प्राण्यांचे जग',
        'emoji': '🐘',
        'color': Colors.green,
        'lesson': 'animals',
      },
      {
        'title': 'आकारांचा खेळ',
        'emoji': '🔺',
        'color': Colors.purple,
        'lesson': 'shapes',
      },
      {
        'title': 'मजेदार प्रश्न',
        'emoji': '⭐',
        'color': Colors.teal,
        'lesson': 'quiz',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5FA),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        title: const Text(
          'तानुची शाळा',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFA6CC),
                    Color(0xFFFFD66B),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Column(
                children: [
                  Text('🎒 🌈 🎈', style: TextStyle(fontSize: 35)),
                  SizedBox(height: 8),
                  Text(
                    'नमस्कार बाळांनो!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF72234D),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'चला खेळूया आणि नवीन गोष्टी शिकूया!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF72234D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              '🌟 चला, खेळ निवडा!',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: games.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final game = games[index];
                final color = game['color'] as Color;

                return InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LearningPage(
                          title: game['title'] as String,
                          emoji: game['emoji'] as String,
                          lesson: game['lesson'] as String,
                          color: color,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: color.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          game['emoji'] as String,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: Text(
                            game['title'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: color.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'खेळूया! ▶',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                '🏆 शिकत राहा, आनंदी राहा!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LearningPage extends StatefulWidget {
  final String title;
  final String emoji;
  final String lesson;
  final Color color;

  const LearningPage({
    super.key,
    required this.title,
    required this.emoji,
    required this.lesson,
    required this.color,
  });

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  int questionIndex = 0;
  int stars = 0;
  String message = 'योग्य उत्तर निवडा!';
  bool answered = false;

  final Map<String, List<Map<String, dynamic>>> lessons = {
    'letters': [
      {'q': 'अ', 'o': ['अ', 'क', 'म'], 'a': 'अ'},
      {'q': 'क', 'o': ['प', 'क', 'त'], 'a': 'क'},
      {'q': 'म', 'o': ['र', 'स', 'म'], 'a': 'म'},
    ],
    'numbers': [
      {'q': '१', 'o': ['३', '१', '२'], 'a': '१'},
      {'q': '२', 'o': ['२', '४', '५'], 'a': '२'},
      {'q': '३', 'o': ['५', '३', '१'], 'a': '३'},
    ],
    'colors': [
      {'q': 'लाल रंग कोणता?', 'o': ['🔵', '🔴', '🟢'], 'a': '🔴'},
      {'q': 'हिरवा रंग कोणता?', 'o': ['🟢', '🟡', '🔵'], 'a': '🟢'},
      {'q': 'निळा रंग कोणता?', 'o': ['🔴', '🟠', '🔵'], 'a': '🔵'},
    ],
    'animals': [
      {'q': 'हत्ती कोणता?', 'o': ['🐘', '🐟', '🐦'], 'a': '🐘'},
      {'q': 'मासा कोणता?', 'o': ['🐄', '🐟', '🐈'], 'a': '🐟'},
      {'q': 'गाय कोणती?', 'o': ['🦁', '🐘', '🐄'], 'a': '🐄'},
    ],
    'shapes': [
      {'q': 'गोल आकार कोणता?', 'o': ['⚪', '🔺', '🟦'], 'a': '⚪'},
      {'q': 'त्रिकोण कोणता?', 'o': ['🟩', '🔺', '⚪'], 'a': '🔺'},
      {'q': 'चौकोन कोणता?', 'o': ['🔺', '⚪', '🟦'], 'a': '🟦'},
    ],
    'quiz': [
      {'q': '२ + १ = ?', 'o': ['२', '३', '४'], 'a': '३'},
      {'q': 'दिवसा आकाशात काय दिसते?', 'o': ['🌙', '☀️', '⭐'], 'a': '☀️'},
      {'q': 'आपण किती नाकांनी वास घेतो?', 'o': ['१', '२', '३'], 'a': '१'},
    ],
  };

  void checkAnswer(String choice) {
    if (answered) return;

    final questions = lessons[widget.lesson]!;
    final correct = choice == questions[questionIndex]['a'];

    setState(() {
      answered = true;
      if (correct) {
        stars++;
        message = 'शाब्बास! ⭐ अगदी बरोबर!';
      } else {
        message = 'छान प्रयत्न! पुन्हा शिकूया 😊';
      }
    });
  }

  void nextQuestion() {
    final questions = lessons[widget.lesson]!;

    setState(() {
      if (questionIndex < questions.length - 1) {
        questionIndex++;
      } else {
        questionIndex = 0;
      }
      answered = false;
      message = 'योग्य उत्तर निवडा!';
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = lessons[widget.lesson]!;
    final current = questions[questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFFFF9E9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                widget.emoji,
                style: const TextStyle(fontSize: 65),
              ),
              Text(
                '⭐ मिळालेले स्टार्स: $stars',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                current['q'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'योग्य उत्तरावर बोट ठेवा',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 18),
              ...((current['o'] as List<String>).map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () => checkAnswer(option),
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 27),
                      ),
                    ),
                  ),
                );
              })),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (answered)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FilledButton.icon(
                    onPressed: nextQuestion,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text(
                      'पुढचा प्रश्न',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
