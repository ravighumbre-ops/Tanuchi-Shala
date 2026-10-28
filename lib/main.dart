
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7255D9),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5FF),
      ),
      home: const HomePage(),
    );
  }
}

typedef WinCallback = Future<void> Function(int earned);

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
    if (earned <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    final newStars = (prefs.getInt('tanu_stars') ?? 0) + earned;
    final newScore = (prefs.getInt('tanu_score') ?? 0) + earned * 10;

    await prefs.setInt('tanu_stars', newStars);
    await prefs.setInt('tanu_score', newScore);

    if (!mounted) return;
    setState(() {
      stars = newStars;
      bestScore = newScore;
    });
  }

  void openGame(String type) {
    late Widget page;

    switch (type) {
      case 'garden':
        page = GardenGame(onWin: saveProgress);
        break;
      case 'letters':
        page = QuizGame(
          title: 'अक्षर ओळखा',
          questions: letterQuestions,
          onWin: saveProgress,
        );
        break;
      case 'numbers':
        page = QuizGame(
          title: 'अंकांची मजा',
          questions: numberQuestions,
          onWin: saveProgress,
        );
        break;
      case 'colors':
        page = QuizGame(
          title: 'रंगांची दुनिया',
          questions: colorQuestions,
          onWin: saveProgress,
        );
        break;
      case 'allGames':
        page = AllGamesPage(onWin: saveProgress);
        break;
      default:
        page = QuizGame(
          title: 'रंगांची दुनिया',
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
                        colors: [
                          Color(0xFF9278F4),
                          Color(0xFF5C9CF5),
                        ],
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
                    '🎮',
                    'आठ मजेदार गेम्स',
                    'प्राणी, फुगे, फळे, आकार आणि आणखी!',
                    const Color(0xFFD9F3FF),
                    () => openGame('allGames'),
                  ),
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
  QuizQuestion('आकाशाचा रंग कोणता?', '☀️',
      ['गुलाबी', 'निळा', 'काळा'], 'निळा'),
  QuizQuestion('गवताचा रंग कोणता?', '🌿',
      ['हिरवा', 'पिवळा', 'लाल'], 'हिरवा'),
  QuizQuestion('केळ्याचा रंग कोणता?', '🍌',
      ['निळा', 'पिवळा', 'जांभळा'], 'पिवळा'),
  QuizQuestion('वांगी कोणत्या रंगाची असतात?', '🍆',
      ['पांढरी', 'जांभळी', 'नारिंगी'], 'जांभळी'),
];

class QuizGame extends StatefulWidget {
  final String title;
  final List<QuizQuestion> questions;
  final WinCallback onWin;

  const QuizGame({
    super.key,
    required this.title,
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

  void choose(String option) {
    if (answered || finished) return;
    final isCorrect = option == widget.questions[index].answer;

    setState(() {
      selected = option;
      answered = true;
      if (isCorrect) correct++;
    });

    SystemSound.play(
      isCorrect ? SystemSoundType.click : SystemSoundType.alert,
    );
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
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$correct / ${widget.questions.length} बरोबर!',
                  style: const TextStyle(fontSize: 23),
                ),
                Text(
                  'तुम्ही $correct स्टार मिळवले! ⭐',
                  style: const TextStyle(fontSize: 19),
                ),
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
            Text('प्रश्न ${index + 1} / ${widget.questions.length}',
                style: const TextStyle(fontSize: 17)),
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

              if (answered && isAnswer) {
                color = const Color(0xFFB9F6CA);
              }
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
                    side: const BorderSide(
                      color: Color(0xFFD6CFFA),
                    ),
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
                selected == q.answer
                    ? '🎉 अगदी बरोबर!'
                    : '😊 योग्य उत्तर: ${q.answer}',
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
    final plantEmoji = !planted ? '🪴' : !watered ? '🌱' : '🌻';

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

class MiniGameInfo {
  final String title;
  final String emoji;
  final Color color;

  const MiniGameInfo(this.title, this.emoji, this.color);
}

const miniGames = [
  MiniGameInfo('प्राणी ओळखा', '🐘', Color(0xFFFFE0B2)),
  MiniGameInfo('फुगे फोडा', '🎈', Color(0xFFFFCDD2)),
  MiniGameInfo('फळांची टोपली', '🍎', Color(0xFFC8E6C9)),
  MiniGameInfo('सशाचा मार्ग', '🐰', Color(0xFFE1BEE7)),
  MiniGameInfo('आकार जुळवा', '🔷', Color(0xFFBBDEFB)),
  MiniGameInfo('तारे मोजा', '⭐', Color(0xFFFFF9C4)),
  MiniGameInfo('छोटा शेफ', '👩‍🍳', Color(0xFFFFE0B2)),
  MiniGameInfo('जादूची जोडी', '🧠', Color(0xFFD1C4E9)),
];

class AllGamesPage extends StatelessWidget {
  final WinCallback onWin;

  const AllGamesPage({super.key, required this.onWin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 आठ मजेदार गेम्स'),
        backgroundColor: const Color(0xFFD9F3FF),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: miniGames.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.86,
        ),
        itemBuilder: (context, i) {
          final game = miniGames[i];
          return InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MiniGamePage(
                  gameIndex: i,
                  onWin: onWin,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: game.color,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(game.emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    game.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('खेळूया! 🚀'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MiniGamePage extends StatefulWidget {
  final int gameIndex;
  final WinCallback onWin;

  const MiniGamePage({
    super.key,
    required this.gameIndex,
    required this.onWin,
  });

  @override
  State<MiniGamePage> createState() => _MiniGamePageState();
}

class _MiniGamePageState extends State<MiniGamePage> {
  final Random random = Random();
  final FlutterTts tts = FlutterTts();

  int round = 0;
  int score = 0;
  int rabbitStep = 0;
  bool finished = false;
  bool saving = false;
  bool chefDone = false;

  final Set<String> ingredients = {};
  late List<String> memoryCards;
  final Set<int> revealed = {};
  final Set<int> matched = {};
  int? firstCard;
  bool checkingPair = false;

  final List<String> animals = ['🐘', '🦁', '🐒', '🐄', '🐶', '🐱'];
  final List<String> animalNames = [
    'हत्ती', 'सिंह', 'माकड', 'गाय', 'कुत्रा', 'मांजर'
  ];
  final List<String> fruits = ['🍎', '🥭', '🍌', '🍇', '🍊', '🍓'];
  final List<String> fruitNames = [
    'सफरचंद', 'आंबा', 'केळे', 'द्राक्षे', 'संत्रे', 'स्ट्रॉबेरी'
  ];
  final List<String> shapeEmoji = ['🔴', '🟦', '🔺', '⭐'];
  final List<String> shapeNames = ['गोल', 'चौकोन', 'त्रिकोण', 'तारा'];
  final List<String> vegetables = ['🥕', '🥔', '🍅', '🥦'];

  @override
  void initState() {
    super.initState();
    _prepareMemory();
    _say('चला बाळांनो, खेळायला सुरुवात करूया!');
  }

  Future<void> _say(String text) async {
    try {
      await tts.setLanguage('mr-IN');
      await tts.setSpeechRate(0.42);
      await tts.speak(text);
    } catch (_) {}
  }

  void _prepareMemory() {
    memoryCards = [
      '🐱', '🐶', '🐸', '🦁',
      '🐱', '🐶', '🐸', '🦁',
    ]..shuffle(random);
  }

  void _correct(String message) {
    if (!mounted || finished) return;

    SystemSound.play(SystemSoundType.click);
    setState(() {
      score++;
      round++;
    });

    _say('शाब्बास! $message');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('शाब्बास! ⭐ $message'),
        duration: const Duration(milliseconds: 800),
        backgroundColor: Colors.green,
      ),
    );

    if (score >= 5) {
      _finishGame();
    }
  }

  void _wrong() {
    SystemSound.play(SystemSoundType.alert);
    _say('पुन्हा प्रयत्न कर बाळा!');
  }

  Future<void> _finishGame() async {
    if (finished) return;

    setState(() {
      finished = true;
      saving = true;
    });

    await widget.onWin(score);

    if (!mounted) return;
    setState(() => saving = false);
    _say('अभिनंदन! खेळ पूर्ण झाला!');
  }

  Widget _option(
    String emoji,
    String label,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        constraints: const BoxConstraints(minHeight: 100),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.orange.shade200, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceGrid(
    List<String> emojis,
    List<String> names,
    int correctIndex,
    String question,
  ) {
    final indices = List<int>.generate(emojis.length, (i) => i)
      ..shuffle(random);
    final shown = indices.take(min(4, indices.length)).toList();

    if (!shown.contains(correctIndex)) {
      shown[random.nextInt(shown.length)] = correctIndex;
    }
    shown.shuffle(random);

    return Column(
      children: [
        Text(
          question,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.08,
          children: shown.map((i) {
            return _option(emojis[i], names[i], () {
              if (i == correctIndex) {
                _correct(names[i]);
              } else {
                _wrong();
              }
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _animalGame() {
    final i = round % animals.length;
    return _choiceGrid(animals, animalNames, i, 'हा कोणता प्राणी आहे?');
  }

  Widget _balloonGame() {
    final letters = ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ'];
    final numbers = ['१', '२', '३', '४', '५', '६'];
    final list = round.isEven ? letters : numbers;
    final correct = list[round % list.length];
    final choices = <String>{correct};

    while (choices.length < 4) {
      choices.add(list[random.nextInt(list.length)]);
    }

    final shown = choices.toList()..shuffle(random);
    final colors = [
      Colors.pink.shade200,
      Colors.blue.shade200,
      Colors.orange.shade200,
      Colors.purple.shade200,
    ];

    return Column(
      children: [
        Text(
          'योग्य फुगा फोडा: $correct',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: List.generate(shown.length, (i) {
            return InkWell(
              onTap: () =>
                  shown[i] == correct ? _correct(correct) : _wrong(),
              child: Container(
                width: 115,
                height: 115,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Text(
                  shown[i],
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _fruitGame() {
    final i = round % fruits.length;
    return _choiceGrid(fruits, fruitNames, i, '${fruitNames[i]} निवडा!');
  }

  Widget _mazeGame() {
    return Column(
      children: [
        const Text(
          'सशाला गाजरापर्यंत पोहोचवा!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text('🥕 गाजर', style: TextStyle(fontSize: 25)),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ...List.generate(
                    rabbitStep,
                    (_) => const Text('🟩', style: TextStyle(fontSize: 25)),
                  ),
                  const Text('🐰', style: TextStyle(fontSize: 32)),
                ],
              ),
              const SizedBox(height: 8),
              Text('पावले: $rabbitStep / 5'),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: rabbitStep >= 5
                  ? null
                  : () {
                      setState(() => rabbitStep++);
                      if (rabbitStep == 5) {
                        _correct('ससा गाजरापर्यंत पोहोचला!');
                      } else {
                        _say('छान! पुढे जा.');
                      }
                    },
              child: const Text('➡️ पुढे जा'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () => setState(() => rabbitStep = 0),
              child: const Text('पुन्हा 🔄'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _shapeGame() {
    final i = round % shapeEmoji.length;
    return _choiceGrid(shapeEmoji, shapeNames, i, '${shapeNames[i]} शोधा!');
  }

  Widget _starGame() {
    final count = round % 10 + 1;
    final choices = <int>{count};

    while (choices.length < 4) {
      choices.add(random.nextInt(10) + 1);
    }

    final shown = choices.toList()..shuffle(random);

    return Column(
      children: [
        const Text(
          'तारे मोजा!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          children: List.generate(
            count,
            (_) => const Text('⭐', style: TextStyle(fontSize: 30)),
          ),
        ),
        const SizedBox(height: 18),
        const Text('किती तारे आहेत?', style: TextStyle(fontSize: 20)),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          children: shown.map((n) {
            return ElevatedButton(
              onPressed: () =>
                  n == count ? _correct('$n तारे') : _wrong(),
              child: Text('$n', style: const TextStyle(fontSize: 23)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _chefGame() {
    const names = ['गाजर', 'बटाटा', 'टोमॅटो', 'ब्रोकोली'];

    return Column(
      children: [
        const Text(
          'चला, भाजी बनवूया! 👩‍🍳',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Text('तीन भाज्या निवडा.'),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: List.generate(vegetables.length, (i) {
            final selected = ingredients.contains(vegetables[i]);
            return SizedBox(
              width: 130,
              child: _option(
                vegetables[i],
                names[i],
                () {
                  setState(() {
                    if (selected) {
                      ingredients.remove(vegetables[i]);
                    } else if (ingredients.length < 3) {
                      ingredients.add(vegetables[i]);
                    }
                  });
                },
                color: selected
                    ? Colors.lightGreen.shade200
                    : Colors.white,
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Text('निवडलेल्या भाज्या: ${ingredients.length}/3'),
        ElevatedButton(
          onPressed: chefDone
              ? null
              : () {
                  if (ingredients.length == 3) {
                    setState(() => chefDone = true);
                    _correct('मस्त भाजी तयार झाली!');
                  } else {
                    _say('तीन भाज्या निवडा!');
                  }
                },
          child: const Text('🍲 भाजी तयार करा'),
        ),
      ],
    );
  }

  Widget _memoryGame() {
    return Column(
      children: [
        const Text(
          'सारखी चित्रे शोधा!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: memoryCards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
          ),
          itemBuilder: (context, i) {
            final visible = revealed.contains(i) || matched.contains(i);
            return InkWell(
              onTap: () => _flipCard(i),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: matched.contains(i)
                      ? Colors.lightGreen.shade200
                      : Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  visible ? memoryCards[i] : '❓',
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Text('जोड्या: ${matched.length ~/ 2} / 4'),
        TextButton(
          onPressed: () => setState(() {
            revealed.clear();
            matched.clear();
            firstCard = null;
            checkingPair = false;
            _prepareMemory();
          }),
          child: const Text('पुन्हा खेळा 🔄'),
        ),
      ],
    );
  }

  void _flipCard(int i) {
    if (checkingPair ||
        revealed.contains(i) ||
        matched.contains(i) ||
        finished) {
      return;
    }

    setState(() => revealed.add(i));

    if (firstCard == null) {
      firstCard = i;
      return;
    }

    final first = firstCard!;
    checkingPair = true;

    if (memoryCards[first] == memoryCards[i]) {
      setState(() {
        matched.add(first);
        matched.add(i);
        revealed.remove(first);
        revealed.remove(i);
        firstCard = null;
        checkingPair = false;
        score++;
      });

      _say('शाब्बास! जोडी मिळाली!');

      if (matched.length == memoryCards.length) {
        _finishGame();
      }
    } else {
      _say('चित्रे लक्षात ठेवा!');
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          revealed.remove(first);
          revealed.remove(i);
          firstCard = null;
          checkingPair = false;
        });
      });
    }
  }

  Widget _gameBody() {
    switch (widget.gameIndex) {
      case 0:
        return _animalGame();
      case 1:
        return _balloonGame();
      case 2:
        return _fruitGame();
      case 3:
        return _mazeGame();
      case 4:
        return _shapeGame();
      case 5:
        return _starGame();
      case 6:
        return _chefGame();
      case 7:
        return _memoryGame();
      default:
        return const Text('खेळ निवडा!');
    }
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = miniGames[widget.gameIndex];

    if (finished) {
      return Scaffold(
        appBar: AppBar(title: Text(game.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏆🌟', style: TextStyle(fontSize: 75)),
                const Text(
                  'शाब्बास!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'या खेळात $score स्टार मिळाले!',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('गेम्सकडे परत चला'),
                ),
                if (saving)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
        backgroundColor: game.color,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Text(
                '⭐ $score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(game.emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                _gameBody(),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _say(
                    'नमस्कार बाळांनो! चला शिकूया आणि खेळूया!',
                  ),
                  icon: const Icon(Icons.volume_up),
                  label: const Text('मराठीत ऐका 🔊'),
                ),
                const SizedBox(height: 8),
                Text(
                  'तुझे स्टार्स: $score ⭐',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.gameIndex != 7)
                  TextButton(
                    onPressed: _finishGame,
                    child: const Text('खेळ पूर्ण करा 🏆'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
