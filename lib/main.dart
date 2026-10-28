
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const TanuShalaApp());
}

// संपूर्ण अ‍ॅपसाठी आवाज
class MarathiVoice {
  static final FlutterTts tts = FlutterTts();
  static bool ready = false;

  static Future<void> init() async {
    if (ready) return;
    try {
      await tts.setLanguage('mr-IN');
      await tts.setSpeechRate(0.42);
      await tts.setVolume(1.0);
      await tts.setPitch(1.0);
      ready = true;
    } catch (e) {
      debugPrint('Voice setup error: $e');
    }
  }

  static Future<void> speak(String text) async {
    try {
      await init();
      await tts.stop();
      await tts.speak(text);
    } catch (e) {
      debugPrint('Voice error: $e');
    }
  }

  static Future<void> stop() async {
    await tts.stop();
  }
}

class TanuShalaApp extends StatelessWidget {
  const TanuShalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'तानूची शाळा',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const sections = [
    {'title': 'मराठी अक्षरे', 'emoji': 'अ', 'color': Colors.pink},
    {'title': 'अंक शिकूया', 'emoji': '🔢', 'color': Colors.blue},
    {'title': 'रंग ओळखा', 'emoji': '🎨', 'color': Colors.orange},
    {'title': 'प्राणी ओळखा', 'emoji': '🐘', 'color': Colors.green},
    {'title': 'छान गोष्टी', 'emoji': '📚', 'color': Colors.deepPurple},
    {'title': 'बागेचा गेम', 'emoji': '🌱', 'color': Colors.teal},
    {'title': 'प्रश्नमंजुषा', 'emoji': '⭐', 'color': Colors.red},
  ];

  void openSection(BuildContext context, int index) {
    Widget page;

    if (index == 0) {
      page = const LearnPage(
        title: 'मराठी अक्षरे',
        items: [
          'अ आ इ ई', 'उ ऊ ऋ', 'ए ऐ ओ औ',
          'क ख ग घ', 'च छ ज झ', 'ट ठ ड ढ',
          'त थ द ध', 'प फ ब भ', 'म य र ल व', 'श ष स ह'
        ],
      );
    } else if (index == 1) {
      page = const LearnPage(
        title: 'अंक शिकूया',
        items: [
          '० - शून्य', '१ - एक', '२ - दोन', '३ - तीन',
          '४ - चार', '५ - पाच', '६ - सहा', '७ - सात',
          '८ - आठ', '९ - नऊ', '१० - दहा'
        ],
      );
    } else if (index == 2) {
      page = const LearnPage(
        title: 'रंग ओळखा',
        items: [
          'लाल', 'निळा', 'हिरवा', 'पिवळा',
          'नारंगी', 'जांभळा', 'काळा', 'पांढरा'
        ],
      );
    } else if (index == 3) {
      page = const LearnPage(
        title: 'प्राणी ओळखा',
        items: [
          'हत्ती', 'सिंह', 'वाघ', 'माकड', 'ससा',
          'कुत्रा', 'मांजर', 'गाय', 'घोडा', 'मोर'
        ],
      );
    } else if (index == 4) {
      page = const StoriesPage();
    } else if (index == 5) {
      page = const GardenGame();
    } else {
      page = const QuizPage();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎒 तानूची शाळा'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade100,
        actions: [
          IconButton(
            tooltip: 'नमस्कार ऐका',
            icon: const Icon(Icons.volume_up),
            onPressed: () => MarathiVoice.speak(
              'नमस्कार मुलांनो! चला, तानूच्या शाळेत खेळत खेळत शिकूया!',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF1FA), Color(0xFFE8F4FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'चला मुलांनो, खेळत खेळत शिकूया! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: sections.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.08,
                ),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  final color = section['color'] as Color;

                  return InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => openSection(context, index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: color, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            section['emoji'] as String,
                            style: const TextStyle(fontSize: 42),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            section['title'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('चला सुरू करूया!'),
                        ],
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

class LearnPage extends StatelessWidget {
  final String title;
  final List<String> items;

  const LearnPage({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'सर्व ऐका',
            icon: const Icon(Icons.volume_up),
            onPressed: () => MarathiVoice.speak(
              '$title. ${items.join('. ')}',
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(
                items[index],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.volume_up,
                  color: Colors.deepPurple,
                ),
                onPressed: () => MarathiVoice.speak(items[index]),
              ),
              onTap: () => MarathiVoice.speak(items[index]),
            ),
          );
        },
      ),
    );
  }
}

class GardenGame extends StatefulWidget {
  const GardenGame({super.key});

  @override
  State<GardenGame> createState() => _GardenGameState();
}

class _GardenGameState extends State<GardenGame> {
  int water = 0;
  bool planted = false;
  bool finished = false;

  void plantSeed() {
    setState(() {
      planted = true;
      water = 0;
      finished = false;
    });
    MarathiVoice.speak('छान! तुम्ही बी पेरले. आता झाडाला पाणी द्या.');
  }

  void waterPlant() {
    if (!planted || finished) return;

    setState(() {
      water++;
      if (water >= 3) finished = true;
    });

    if (finished) {
      MarathiVoice.speak('शाब्बास! तुमचे झाड मोठे झाले! तुम्हाला एक तारा मिळाला.');
    } else {
      MarathiVoice.speak('छान! झाडाला पाणी मिळाले. आणखी पाणी द्या.');
    }
  }

  void restart() {
    setState(() {
      water = 0;
      planted = false;
      finished = false;
    });
    MarathiVoice.speak('चला, पुन्हा खेळूया!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌱 बागेचा गेम'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => MarathiVoice.speak(
              'बी पेरा आणि झाड वाढवा. बी पेरण्यासाठी बटण दाबा.',
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'बी पेरा आणि झाड वाढवा!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                finished
                    ? '🌳'
                    : water == 2
                        ? '🌿'
                        : water == 1
                            ? '🌱'
                            : planted
                                ? '🫘'
                                : '🪴',
                style: const TextStyle(fontSize: 100),
              ),
              const SizedBox(height: 16),
              Text(
                finished
                    ? 'शाब्बास! झाड मोठे झाले! ⭐'
                    : planted
                        ? 'झाडाला पाणी द्या: $water/3'
                        : 'आधी मातीत बी पेरा.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 25),
              if (!planted)
                ElevatedButton.icon(
                  onPressed: plantSeed,
                  icon: const Icon(Icons.grass),
                  label: const Text('बी पेरा'),
                ),
              if (planted && !finished)
                ElevatedButton.icon(
                  onPressed: waterPlant,
                  icon: const Icon(Icons.water_drop),
                  label: const Text('पाणी द्या 💧'),
                ),
              if (finished)
                const Text(
                  'तुम्हाला १ तारा मिळाला! ⭐',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: restart,
                child: const Text('पुन्हा खेळा'),
              ),
            ],
          ),
        ),
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
  int questionIndex = 0;
  int score = 0;
  bool answered = false;
  String feedback = '';

  final List<Map<String, dynamic>> questions = const [
    {
      'question': 'आपला राष्ट्रीय पक्षी कोणता?',
      'options': ['मोर', 'कावळा', 'चिमणी'],
      'answer': 0,
    },
    {
      'question': '२ + ३ किती?',
      'options': ['४', '५', '६'],
      'answer': 1,
    },
    {
      'question': 'गवताचा रंग कोणता?',
      'options': ['लाल', 'निळा', 'हिरवा'],
      'answer': 2,
    },
    {
      'question': 'गाय आपल्याला काय देते?',
      'options': ['दूध', 'पेट्रोल', 'पाणीपुरी'],
      'answer': 0,
    },
    {
      'question': 'आठवड्यात किती दिवस असतात?',
      'options': ['५', '७', '१०'],
      'answer': 1,
    },
  ];

  void chooseAnswer(int index) {
    if (answered) return;

    setState(() {
      answered = true;
      if (index == questions[questionIndex]['answer']) {
        score++;
        feedback = 'बरोबर उत्तर! 🎉';
      } else {
        feedback = 'चांगला प्रयत्न! पुन्हा शिकूया 😊';
      }
    });

    MarathiVoice.speak(feedback);
  }

  void nextQuestion() {
    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex++;
        answered = false;
        feedback = '';
      });
      MarathiVoice.speak(questions[questionIndex]['question'] as String);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResult(
            score: score,
            total: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[questionIndex];
    final options = question['options'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('⭐ प्रश्नमंजुषा'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: 'प्रश्न ऐका',
            onPressed: () => MarathiVoice.speak(
              question['question'] as String,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'प्रश्न ${questionIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              question['question'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(options.length, (index) {
              return SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: answered
                        ? null
                        : () => chooseAnswer(index),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        options[index],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              );
            }),
            Text(
              feedback,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (answered)
              ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                  questionIndex == questions.length - 1
                      ? 'निकाल पाहा'
                      : 'पुढचा प्रश्न',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class QuizResult extends StatelessWidget {
  final int score;
  final int total;

  const QuizResult({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('तुमचा निकाल')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 90)),
            const Text(
              'शाब्बास!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'तुमचे गुण: $score / $total',
              style: const TextStyle(fontSize: 24),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up, size: 36),
              onPressed: () => MarathiVoice.speak(
                'शाब्बास! तुम्हाला $total पैकी $score गुण मिळाले.',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('मुख्य पानावर जा'),
            ),
          ],
        ),
      ),
    );
  }
}

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  static const stories = [
    {
      'title': 'ससा आणि कासव',
      'story':
          'एकदा ससा आणि कासव यांच्यात शर्यत लागली. '
          'ससा वेगाने धावला, पण मध्ये झोपला. '
          'कासव हळूहळू चालत राहिले आणि शर्यत जिंकले. '
          'बोध: सातत्याने प्रयत्न केले तर यश मिळते.'
    },
    {
      'title': 'तहानलेला कावळा',
      'story':
          'एका कावळ्याला पाणी मिळेना. त्याला एका भांड्यात थोडे पाणी '
          'दिसले. त्याने त्यात दगड टाकले. पाणी वर आले आणि त्याने पाणी '
          'प्यायले. बोध: बुद्धीचा वापर करा.'
    },
    {
      'title': 'मुंगी आणि कबूतर',
      'story':
          'मुंगी पाण्यात पडली. कबुतराने पान टाकून तिची मदत केली. '
          'नंतर मुंगीनेही कबुतराला संकटातून वाचवले. '
          'बोध: दुसऱ्यांना मदत करा.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 छान गोष्टी'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: 'गोष्टी ऐका',
            onPressed: () async {
              for (final story in stories) {
                await MarathiVoice.speak(
                  '${story['title']}. ${story['story']}',
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: stories.map((story) {
          return Card(
            child: ExpansionTile(
              leading: const Icon(
                Icons.menu_book,
                color: Colors.deepPurple,
              ),
              title: Text(
                story['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => MarathiVoice.speak(
                  '${story['title']}. ${story['story']}',
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    story['story']!,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
