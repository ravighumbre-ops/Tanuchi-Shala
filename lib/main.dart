
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TanuChiShalaApp());
}

class TanuChiShalaApp extends StatelessWidget {
  const TanuChiShalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'तानूची शाळा',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7255D9),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5FF),
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
  int bestScore = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      stars = prefs.getInt('tanu_stars') ?? 0;
      bestScore = prefs.getInt('tanu_score') ?? 0;
      loading = false;
    });
  }

  Future<void> saveProgress(int earned) async {
    final prefs = await SharedPreferences.getInstance();
    stars += earned;
    bestScore += earned * 10;
    await prefs.setInt('tanu_stars', stars);
    await prefs.setInt('tanu_score', bestScore);
    if (mounted) setState(() {});
  }

  void openGame(String type) {
    Widget page;

    switch (type) {
      case 'garden':
        page = GardenGame(onWin: saveProgress);
        break;
      case 'letters':
        page = QuizGame(
          title: 'अक्षर ओळखा',
          emoji: '🔤',
          questions: letterQuestions,
          onWin: saveProgress,
        );
        break;
      case 'numbers':
        page = QuizGame(
          title: 'अंकांची मजा',
          emoji: '🔢',
          questions: numberQuestions,
          onWin: saveProgress,
        );
        break;
      default:
        page = QuizGame(
          title: 'रंग ओळखा',
          emoji: '🎨',
          questions: colorQuestions,
          onWin: saveProgress,
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'तानूची शाळा 🎒',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF5336A6),
                          ),
                        ),
                      ),
                      const Text('⭐', style: TextStyle(fontSize: 25)),
                      Text(
                        '$stars',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9278F4), Color(0xFF5C9CF5)],
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('👧🏻 🌈 🧸',
                            style: TextStyle(fontSize: 44)),
                        SizedBox(height: 8),
                        Text(
                          'नमस्कार मित्रांनो!',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'खेळूया, शिकूया आणि स्टार मिळवूया!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: statCard(
                          '⭐',
                          '$stars',
                          'एकूण स्टार',
                          const Color(0xFFFFF0C9),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: statCard(
                          '🏆',
                          '$bestScore',
                          'एकूण गुण',
                          const Color(0xFFDDF6E5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'चला, खेळ सुरू करूया!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  gameCard(
                    '🌱',
                    'जादूची बाग',
                    'बी पेरा, पाणी द्या, झाड वाढवा',
                    const Color(0xFFDDF6E5),
                    () => openGame('garden'),
                  ),
                  gameCard(
                    '🔤',
                    'मराठी अक्षरे',
                    'अक्षर ओळखा आणि उत्तर द्या',
                    const Color(0xFFFFE5E9),
                    () => openGame('letters'),
                  ),
                  gameCard(
                    '🔢',
                    'अंकांची मजा',
                    '१, २, ३... शिकूया!',
                    const Color(0xFFFFF0C9),
                    () => openGame('numbers'),
                  ),
                  gameCard(
                    '🎨',
                    'रंगांची दुनिया',
                    'रंग ओळखा आणि जिंका',
                    const Color(0xFFE9E1FF),
                    () => openGame('colors'),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      '💖 शिकणे म्हणजे मजा!',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7255D9),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget statCard(
    String emoji,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 29)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget gameCard(
    String emoji,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      color: color,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 43)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_fill, size: 34),
            ],
          ),
        ),
      ),
    );
  }
}

typedef WinCallback = Future<void> Function(int earned);

class QuizQuestion {
  final String question;
  final String emoji;
  final List<String> options;
  final String answer;

  const QuizQuestion(
    this.question,
    this.emoji,
    this.options,
    this.answer,
  );
}

const List<QuizQuestion> letterQuestions = [
  QuizQuestion('अननस कोणत्या अक्षराने सुरू होते?', '🍍',
      ['अ', 'क', 'म'], 'अ'),
  QuizQuestion('कमळ कोणत्या अक्षराने सुरू होते?', '🌸',
      ['प', 'क', 'ग'], 'क'),
  QuizQuestion('मासा कोणत्या अक्षराने सुरू होतो?', '🐟',
      ['म', 'स', 'र'], 'म'),
  QuizQuestion('घर कोणत्या अक्षराने सुरू होते?', '🏠',
      ['घ', 'च', 'न'], 'घ'),
  QuizQuestion('फळ कोणत्या अक्षराने सुरू होते?', '🍎',
      ['व', 'फ', 'ट'], 'फ'),
];

const List<QuizQuestion> numberQuestions = [
  QuizQuestion('🍎 किती सफरचंद आहेत?', '🍎', ['१', '२', '३'], '१'),
  QuizQuestion('🐥🐥 किती पिल्ले आहेत?', '🐥🐥', ['१', '२', '३'], '२'),
  QuizQuestion('⭐ ⭐ ⭐ किती तारे आहेत?', '⭐', ['२', '३', '४'], '३'),
  QuizQuestion('🍌🍌 किती केळी आहेत?', '🍌🍌', ['३', '२', '१'], '२'),
  QuizQuestion('🐱🐱🐱🐱 किती मांजरे आहेत?', '🐱',
      ['४', '३', '५'], '४'),
];

const List<QuizQuestion> colorQuestions = [
  QuizQuestion('लाल रंग कोणता?', '❤️', ['लाल', 'निळा', 'हिरवा'], 'लाल'),
  QuizQuestion('आकाशाचा रंग कोणता?', '☀️', ['गुलाबी', 'निळा', 'काळा'], 'निळा'),
  QuizQuestion('गवताचा रंग कोणता?', '🌿', ['हिरवा', 'पिवळा', 'लाल'], 'हिरवा'),
  QuizQuestion('केळ्याचा रंग कोणता?', '🍌', ['निळा', 'पिवळा', 'जांभळा'], 'पिवळा'),
  QuizQuestion('वांगी कोणत्या रंगाची असतात?', '🍆',
      ['पांढरी', 'जांभळी', 'नारिंगी'], 'जांभळी'),
];

class QuizGame extends StatefulWidget {
  final String title;
  final String emoji;
  final List<QuizQuestion> questions;
  final WinCallback onWin;

  const QuizGame({
    super.key,
    required this.title,
    required this.emoji,
    required this.questions,
    required this.onWin,
  });

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  int index = 0;
  int correct = 0;
  String? selected;
  bool answered = false;
  bool finished = false;
  bool saving = false;

  Future<void> choose(String option) async {
    if (answered || finished) return;

    final isCorrect = option == widget.questions[index].answer;
    setState(() {
      selected = option;
      answered = true;
      if (isCorrect) correct++;
    });
  }

  Future<void> next() async {
    if (index < widget.questions.length - 1) {
      setState(() {
        index++;
        selected = null;
        answered = false;
      });
    } else {
      setState(() {
        finished = true;
        saving = true;
      });
      await widget.onWin(correct);
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 80)),
                const Text(
                  'शाब्बास!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  '$correct / ${widget.questions.length} बरोबर!',
                  style: const TextStyle(fontSize: 23),
                ),
                Text('तुम्ही $correct स्टार मिळवले! ⭐',
                    style: const TextStyle(fontSize: 19)),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: saving ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.home),
                  label: const Text('मुख्य स्क्रीनवर चला'),
                ),
                if (saving) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      );
    }

    final q = widget.questions[index];

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (index + 1) / widget.questions.length,
              minHeight: 9,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 18),
            Text(
              'प्रश्न ${index + 1} / ${widget.questions.length}',
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 24),
            Text(q.emoji, style: const TextStyle(fontSize: 65)),
            const SizedBox(height: 18),
            Text(
              q.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            ...q.options.map((option) {
              final isAnswer = option == q.answer;
              Color color = Colors.white;
              if (answered && isAnswer) color = const Color(0xFFB9F6CA);
              if (answered && selected == option && !isAnswer) {
                color = const Color(0xFFFFCDD2);
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.all(17),
                    side: const BorderSide(color: Color(0xFFD6CFFA)),
                  ),
                  onPressed: answered ? null : () => choose(option),
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
            if (answered) ...[
              const SizedBox(height: 8),
              Text(
                selected == q.answer ? '🎉 अगदी बरोबर!' : '😊 योग्य उत्तर: ${q.answer}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: next,
                  child: Text(
                    index == widget.questions.length - 1
                        ? 'निकाल पाहा 🏆'
                        : 'पुढचा प्रश्न ➜',
                  ),
                ),
              ),
            ] else
              const Spacer(),
          ],
        ),
      ),
    );
  }
}

class GardenGame extends StatefulWidget {
  final WinCallback onWin;

  const GardenGame({super.key, required this.onWin});

  @override
  State<GardenGame> createState() => _GardenGameState();
}

class _GardenGameState extends State<GardenGame> {
  bool planted = false;
  bool watered = false;
  bool finished = false;
  bool saving = false;

  Future<void> complete() async {
    setState(() {
      finished = true;
      saving = true;
    });
    await widget.onWin(3);
    if (mounted) setState(() => saving = false);
  }

  @override
  Widget build(BuildContext context) {
    String plantEmoji = !planted
        ? '🪴'
        : !watered
            ? '🌱'
            : '🌻';

    return Scaffold(
      appBar: AppBar(title: const Text('जादूची बाग 🌱')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'आपली छोटी बाग वाढवूया!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF6E5),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Text(
                    plantEmoji,
                    style: const TextStyle(fontSize: 115),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              finished
                  ? 'वा! तुमची बाग फुलली! 🌻'
                  : !planted
                      ? 'पहिली पायरी: बी पेरा.'
                      : !watered
                          ? 'दुसरी पायरी: झाडाला पाणी द्या.'
                          : 'छान! तुमचे झाड वाढले!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 18),
            if (!planted)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => setState(() => planted = true),
                  child: const Text('🌰 बी पेरा'),
                ),
              )
            else if (!watered)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => setState(() => watered = true),
                  child: const Text('💧 पाणी द्या'),
                ),
              )
            else if (!finished)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: complete,
                  child: const Text('⭐ बाग पूर्ण करा'),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: saving ? null : () => Navigator.pop(context),
                  child: const Text('मुख्य स्क्रीनवर चला'),
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
