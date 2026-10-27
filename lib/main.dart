
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8E7),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      ['मराठी अक्षरे', 'अ आ इ ई', Icons.menu_book, Colors.pink, 'letters'],
      ['अंक शिकूया', '१ २ ३ ४', Icons.looks_one, Colors.blue, 'numbers'],
      ['रंग ओळखा', '🌈 रंगीत जग', Icons.palette, Colors.orange, 'colors'],
      ['प्रश्नमंजुषा', 'खेळा आणि तारे मिळवा', Icons.emoji_events, Colors.purple, 'quiz'],
      ['प्राण्यांची दुनिया', '🐘 🐒 🦁', Icons.pets, Colors.green, 'animals'],
      ['आकार शिकूया', '○ □ △', Icons.category, Colors.teal, 'shapes'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎈 तानुची शाळा'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFD66B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD6E7),
                  Color(0xFFD9E8FF),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: [
                Text(
                  '🌟 नमस्कार छोट्या दोस्ता! 🌟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'खेळत खेळत शिकूया आणि चमकूया!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 12),
                Text('🧸 📚 🎨 🚀',
                    style: TextStyle(fontSize: 32)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'आज काय शिकायचे?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...lessons.map((lesson) {
            final title = lesson[0] as String;
            final subtitle = lesson[1] as String;
            final icon = lesson[2] as IconData;
            final color = lesson[3] as Color;
            final type = lesson[4] as String;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 27,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color, size: 30),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(subtitle),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (type == 'quiz') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuizPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonPage(
                          title: title,
                          type: type,
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }),
          const Center(child: Text('💖 रोज थोडे शिकूया! 💖')),
        ],
      ),
    );
  }
}

class LessonPage extends StatelessWidget {
  final String title;
  final String type;

  const LessonPage({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    List<String> items;

    switch (type) {
      case 'letters':
        items = [
          'अ', 'आ', 'इ', 'ई', 'उ', 'ऊ',
          'ए', 'ऐ', 'ओ', 'औ', 'क', 'ख', 'ग', 'घ',
        ];
        break;
      case 'numbers':
        items = ['१', '२', '३', '४', '५', '६', '७', '८', '९', '१०'];
        break;
      case 'colors':
        items = [
          '🔴 लाल', '🔵 निळा', '🟡 पिवळा',
          '🟢 हिरवा', '🟣 जांभळा', '🟠 नारिंगी',
        ];
        break;
      case 'animals':
        items = [
          '🐘 हत्ती', '🦁 सिंह', '🐒 माकड',
          '🐱 मांजर', '🐶 कुत्रा', '🐰 ससा',
        ];
        break;
      default:
        items = [
          '⚪ वर्तुळ', '🟥 चौकोन',
          '🔺 त्रिकोण', '⭐ तारा', '❤️ हृदय',
        ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFFD66B),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.25,
        ),
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            child: Center(
              child: Text(
                items[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, Object>> questions = const [
    {
      'question': 'मराठीतील पहिले अक्षर कोणते?',
      'options': ['अ', 'क', 'म'],
      'answer': 'अ',
    },
    {
      'question': '२ नंतर कोणता अंक येतो?',
      'options': ['१', '३', '५'],
      'answer': '३',
    },
    {
      'question': 'गवताचा रंग कोणता?',
      'options': ['लाल', 'हिरवा', 'निळा'],
      'answer': 'हिरवा',
    },
    {
      'question': 'जंगलाचा राजा कोण?',
      'options': ['सिंह', 'ससा', 'मांजर'],
      'answer': 'सिंह',
    },
    {
      'question': 'आपल्याला प्रकाश कोण देतो?',
      'options': ['चंद्र', 'सूर्य', 'ढग'],
      'answer': 'सूर्य',
    },
  ];

  int index = 0;
  int score = 0;
  bool answered = false;
  bool finished = false;

  void chooseAnswer(String option) {
    if (answered || finished) return;

    final correct = option == questions[index]['answer'];

    setState(() {
      answered = true;
      if (correct) score++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          correct
              ? '🎉🥳 व्वा! अगदी बरोबर! तू खूप हुशार आहेस! 🏆👏'
              : '😊 काही हरकत नाही! योग्य उत्तर: ${questions[index]['answer']}',
        ),
        backgroundColor:
            correct ? Colors.green : Colors.deepPurple,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void nextQuestion() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        answered = false;
      });
    } else {
      setState(() {
        finished = true;
      });
    }
  }

  void restartQuiz() {
    setState(() {
      index = 0;
      score = 0;
      answered = false;
      finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Scaffold(
        appBar: AppBar(title: const Text('प्रश्नमंजुषा')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🏆🎉 शाब्बास चॅम्पियन! 🎉🏆',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${questions.length} पैकी $score प्रश्नांची उत्तरे बरोबर!\n\n'
                  '🥳 तू खूप छान खेळलास!\n'
                  '💖 आम्हाला तुझा अभिमान आहे!\n'
                  '🚀 असाच शिकत राहा!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: restartQuiz,
                  icon: const Icon(Icons.refresh),
                  label: const Text('🔄 पुन्हा खेळ'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('🏠 घरी जा'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = questions[index];
    final options = question['options'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌟 प्रश्नमंजुषा'),
        backgroundColor: const Color(0xFFFFD66B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (index + 1) / questions.length,
            ),
            const SizedBox(height: 14),
            Text(
              'प्रश्न ${index + 1} / ${questions.length}   ⭐ गुण: $score',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE4E9FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question['question'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...options.map((option) {
              final isCorrect = option == question['answer'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: answered && isCorrect
                        ? Colors.green
                        : Colors.white,
                    foregroundColor: Colors.black87,
                  ),
                  onPressed: answered
                      ? null
                      : () => chooseAnswer(option),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 21),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (answered)
              ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                  index == questions.length - 1
                      ? '🏁 निकाल पाहा'
                      : '➡️ पुढचा प्रश्न',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
