import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TanuchiShalaApp());
}

class TanuchiShalaApp extends StatelessWidget {
  const TanuchiShalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'टुनटुन शाळा',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int stars = 0;

  final List<Map<String, dynamic>> games = [
    {'title': 'मराठी अक्षरे', 'emoji': '🔤', 'color': Colors.pink, 'type': 'letters'},
    {'title': 'अंक शिकूया', 'emoji': '🔢', 'color': Colors.blue, 'type': 'numbers'},
    {'title': 'रंग ओळखा', 'emoji': '🎨', 'color': Colors.orange, 'type': 'colors'},
    {'title': 'प्राणी ओळखा', 'emoji': '🦁', 'color': Colors.green, 'type': 'animals'},
    {'title': 'आकार शिकूया', 'emoji': '🔺', 'color': Colors.purple, 'type': 'shapes'},
    {'title': 'प्रश्नमंजुषा', 'emoji': '🧠', 'color': Colors.teal, 'type': 'quiz'},
    {'title': 'माझी बाग', 'emoji': '🌱', 'color': Colors.lightGreen, 'type': 'garden'},
    {'title': 'गोड गोष्टी', 'emoji': '📚', 'color': Colors.deepOrange, 'type': 'stories'},
  ];

  @override
  void initState() {
    super.initState();
    loadStars();
  }

  Future<void> loadStars() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => stars = prefs.getInt('stars') ?? 0);
  }

  Future<void> addStar() async {
    final prefs = await SharedPreferences.getInstance();
    stars++;
    await prefs.setInt('stars', stars);
    if (mounted) setState(() {});
  }

  void openGame(Map<String, dynamic> game) {
    final type = game['type'] as String;

    if (type == 'garden') {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => GardenPage(onStar: addStar),
      ));
    } else if (type == 'stories') {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => const StoriesPage(),
      ));
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => LearningPage(
          title: game['title'] as String,
          type: type,
          color: game['color'] as Color,
          onStar: addStar,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE5F1), Color(0xFFE4F4FF), Color(0xFFFFF3D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7657E8), Color(0xFFB65DE8)],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text('🎈 🧸 🎈', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        const Text(
                          'टुनटुन शाळा',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'खेळूया, शिकूया आणि मजा करूया!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            '⭐ माझे तारे: $stars',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    '🎮 चला, खेळ सुरू करूया!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final game = games[index];
                      final color = game['color'] as Color;
                      return InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () => openGame(game),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: color.withValues(alpha: 0.35),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.18),
                                blurRadius: 9,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  game['emoji'] as String,
                                  style: const TextStyle(fontSize: 38),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  game['title'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Icon(Icons.play_circle_fill, color: color, size: 26),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: games.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.91,
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

class LearningPage extends StatefulWidget {
  final String title;
  final String type;
  final Color color;
  final Future<void> Function() onStar;

  const LearningPage({
    super.key,
    required this.title,
    required this.type,
    required this.color,
    required this.onStar,
  });

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  int index = 0;
  int score = 0;

  final Map<String, List<Map<String, String>>> lessons = {
    'letters': [
      {'q': 'अ', 'hint': 'अ पासून अननस 🍍', 'answer': 'अननस'},
      {'q': 'आ', 'hint': 'आ पासून आंबा 🥭', 'answer': 'आंबा'},
      {'q': 'इ', 'hint': 'इ पासून इमारत 🏢', 'answer': 'इमारत'},
      {'q': 'ई', 'hint': 'ई पासून ईश्वर 🙏', 'answer': 'ईश्वर'},
      {'q': 'उ', 'hint': 'उ पासून उंदीर 🐭', 'answer': 'उंदीर'},
    ],
    'numbers': [
      {'q': '१', 'hint': '🍎', 'answer': 'एक'},
      {'q': '२', 'hint': '🍎 🍎', 'answer': 'दोन'},
      {'q': '३', 'hint': '🍎 🍎 🍎', 'answer': 'तीन'},
      {'q': '४', 'hint': '⭐ ⭐ ⭐ ⭐', 'answer': 'चार'},
      {'q': '५', 'hint': '🌼 🌼 🌼 🌼 🌼', 'answer': 'पाच'},
    ],
    'colors': [
      {'q': 'लाल', 'hint': '🍎', 'answer': 'लाल'},
      {'q': 'पिवळा', 'hint': '🍌', 'answer': 'पिवळा'},
      {'q': 'हिरवा', 'hint': '🍃', 'answer': 'हिरवा'},
      {'q': 'निळा', 'hint': '🌊', 'answer': 'निळा'},
      {'q': 'केशरी', 'hint': '🍊', 'answer': 'केशरी'},
    ],
    'animals': [
      {'q': 'सिंह', 'hint': '🦁', 'answer': 'सिंह'},
      {'q': 'हत्ती', 'hint': '🐘', 'answer': 'हत्ती'},
      {'q': 'मांजर', 'hint': '🐱', 'answer': 'मांजर'},
      {'q': 'कुत्रा', 'hint': '🐶', 'answer': 'कुत्रा'},
      {'q': 'ससा', 'hint': '🐰', 'answer': 'ससा'},
    ],
    'shapes': [
      {'q': 'वर्तुळ', 'hint': '🔴', 'answer': 'वर्तुळ'},
      {'q': 'चौरस', 'hint': '🟦', 'answer': 'चौरस'},
      {'q': 'त्रिकोण', 'hint': '🔺', 'answer': 'त्रिकोण'},
      {'q': 'तारा', 'hint': '⭐', 'answer': 'तारा'},
      {'q': 'हृदय', 'hint': '❤️', 'answer': 'हृदय'},
    ],
    'quiz': [
      {'q': 'गवताचा रंग कोणता?', 'hint': '🌱', 'answer': 'हिरवा'},
      {'q': 'एका हाताला किती बोटे?', 'hint': '✋', 'answer': 'पाच'},
      {'q': 'दूध कोण देते?', 'hint': '🐄', 'answer': 'गाय'},
      {'q': 'सूर्य कधी उगवतो?', 'hint': '🌞', 'answer': 'सकाळी'},
      {'q': 'आकाशाचा रंग?', 'hint': '☁️', 'answer': 'निळा'},
    ],
  };

  List<Map<String, String>> get questions => lessons[widget.type] ?? [];

  @override
  Widget build(BuildContext context) {
    final item = questions[index];
    final isQuiz = widget.type == 'quiz';

    List<String> options;
    if (widget.type == 'letters') {
      options = ['अननस', 'आंबा', 'इमारत', 'उंदीर'];
    } else if (widget.type == 'numbers') {
      options = ['एक', 'दोन', 'तीन', 'चार', 'पाच'];
    } else if (widget.type == 'colors') {
      options = ['लाल', 'पिवळा', 'हिरवा', 'निळा', 'केशरी'];
    } else if (widget.type == 'animals') {
      options = ['सिंह', 'हत्ती', 'मांजर', 'कुत्रा', 'ससा'];
    } else if (widget.type == 'shapes') {
      options = ['वर्तुळ', 'चौरस', 'त्रिकोण', 'तारा', 'हृदय'];
    } else {
      options = ['हिरवा', 'पाच', 'गाय', 'सकाळी', 'निळा'];
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: widget.color),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.color.withValues(alpha: 0.12), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('प्रश्न ${index + 1} / ${questions.length}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(item['q']!, textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 18),
                      Text(item['hint']!, textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 38)),
                      const SizedBox(height: 22),
                      Text(isQuiz ? 'योग्य उत्तर निवड!' : 'योग्य उत्तरावर टिचकी मार!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 17)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: options.map((option) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                      ),
                      onPressed: () async {
                        if (option == item['answer']) {
                          score++;
                          await widget.onStar();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('शाब्बास! ⭐ बरोबर उत्तर!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('पुन्हा प्रयत्न कर 😊')),
                          );
                        }
                        if (option == item['answer']) {
                          if (index < questions.length - 1) {
                            setState(() => index++);
                          } else {
                            showDialog<void>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('🎉 खूप छान!'),
                                content: Text('तू $score पैकी ${questions.length} प्रश्न पूर्ण केलेस!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('घरी जा'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        index = 0;
                                        score = 0;
                                      });
                                    },
                                    child: const Text('पुन्हा खेळ'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: Text(option, style: const TextStyle(fontSize: 17)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GardenPage extends StatefulWidget {
  final Future<void> Function() onStar;

  const GardenPage({super.key, required this.onStar});

  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  int water = 0;
  bool planted = false;
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌱 माझी बाग')),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE2FFD9), Color(0xFFFFF5D8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('आपली छोटी बाग बनवूया!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 35),
              Text(finished ? '🌻' : water > 0 ? '🌿' : planted ? '🌱' : '🟤',
                  style: const TextStyle(fontSize: 100)),
              const SizedBox(height: 20),
              Text(
                finished ? 'वा! सुंदर फूल उमलले!' : planted ? 'झाडाला पाणी दे!' : 'आधी बी पेर!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text('💧 पाणी: $water / 3', style: const TextStyle(fontSize: 19)),
              const SizedBox(height: 25),
              if (!planted)
                ElevatedButton.icon(
                  onPressed: () => setState(() => planted = true),
                  icon: const Icon(Icons.grass),
                  label: const Text('बी पेरा'),
                )
              else if (!finished)
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() => water++);
                    if (water >= 3) {
                      setState(() => finished = true);
                      await widget.onStar();
                    }
                  },
                  icon: const Icon(Icons.water_drop),
                  label: const Text('पाणी दे'),
                )
              else
                ElevatedButton(
                  onPressed: () => setState(() {
                    water = 0;
                    planted = false;
                    finished = false;
                  }),
                  child: const Text('पुन्हा बाग लाव'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  final FlutterTts tts = FlutterTts();
  int selected = 0;

  final List<Map<String, String>> stories = [
    {
      'title': 'ससा आणि कासव 🐰🐢',
      'text': 'एक ससा आणि एक कासव होते. ससा खूप वेगाने धावत असे. एके दिवशी दोघांची शर्यत लागली. ससा झोपून गेला. कासव हळूहळू चालत पुढे गेले आणि जिंकले. बोध: प्रयत्न करत राहावे.'
    },
    {
      'title': 'तहानलेला कावळा 🐦',
      'text': 'एका कावळ्याला खूप तहान लागली. त्याला एका भांड्यात थोडे पाणी दिसले. त्याने भांड्यात छोटे दगड टाकले. पाणी वर आले आणि कावळ्याने पाणी प्यायले. बोध: बुद्धीचा वापर करा.'
    },
    {
      'title': 'मुंगी आणि कबूतर 🐜🕊️',
      'text': 'एक मुंगी पाण्यात पडली. कबुतराने पान टाकून तिची मदत केली. नंतर एका शिकाऱ्यापासून मुंगीने कबुतराला वाचवले. बोध: दुसऱ्याला मदत केली तर मदत मिळते.'
    },
  ];

  Future<void> speak(String text) async {
    await tts.setLanguage('mr-IN');
    await tts.setSpeechRate(0.42);
    await tts.speak(text);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = stories[selected];
    return Scaffold(
      appBar: AppBar(title: const Text('📚 गोड गोष्टी')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('एक गोष्ट ऐकूया!', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ...List.generate(stories.length, (i) {
            return Card(
              child: ListTile(
                leading: const Text('📖', style: TextStyle(fontSize: 28)),
                title: Text(stories[i]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                selected: selected == i,
                onTap: () => setState(() => selected = i),
              ),
            );
          }),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(story['title']!, textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Text(story['text']!, style: const TextStyle(fontSize: 18, height: 1.6)),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () => speak(story['text']!),
                  icon: const Icon(Icons.volume_up),
                  label: const Text('गोष्ट ऐका 🔊'),
                ),
                TextButton.icon(
                  onPressed: () => tts.stop(),
                  icon: const Icon(Icons.stop),
                  label: const Text('थांबवा'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
