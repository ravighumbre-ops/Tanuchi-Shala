
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TunTunShalaApp());
}

class TunTunShalaApp extends StatelessWidget {
  const TunTunShalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'तानूची शाळा',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  int quizzesPlayed = 0;
  int storiesRead = 0;
  int gamesPlayed = 0;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      stars = prefs.getInt('stars') ?? 0;
      bestScore = prefs.getInt('bestScore') ?? 0;
      quizzesPlayed = prefs.getInt('quizzesPlayed') ?? 0;
      storiesRead = prefs.getInt('storiesRead') ?? 0;
      gamesPlayed = prefs.getInt('gamesPlayed') ?? 0;
    });
  }

  Future<void> saveProgress({
    int addStars = 0,
    int? score,
    bool quiz = false,
    bool story = false,
    bool game = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    stars += addStars;
    if (score != null && score > bestScore) bestScore = score;
    if (quiz) quizzesPlayed++;
    if (story) storiesRead++;
    if (game) gamesPlayed++;

    await prefs.setInt('stars', stars);
    await prefs.setInt('bestScore', bestScore);
    await prefs.setInt('quizzesPlayed', quizzesPlayed);
    await prefs.setInt('storiesRead', storiesRead);
    await prefs.setInt('gamesPlayed', gamesPlayed);

    if (mounted) setState(() {});
  }

  void openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = [
      ('🔤', 'अक्षरे आणि बाराखडी', const LearnPage()),
      ('🧠', 'प्रश्नमंजुषा', QuizPage(onFinish: (score, total) {
        saveProgress(
          addStars: score,
          score: score,
          quiz: true,
        );
      })),
      ('🌱', 'बाग फुलवण्याचा गेम', GardenGame(onFinish: () {
        saveProgress(addStars: 3, game: true);
      })),
      ('📖', 'मराठी गोष्टी', StoriesPage(onRead: () {
        saveProgress(story: true);
      })),
      ('🏆', 'माझी प्रगती', ProgressPage(
        stars: stars,
        bestScore: bestScore,
        quizzes: quizzesPlayed,
        stories: storiesRead,
        games: gamesPlayed,
      )),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎒 तानूची शाळा'),
        backgroundColor: const Color(0xFFFFD66B),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF4D8), Color(0xFFEDE7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'चला शिकूया, खेळूया आणि स्टार्स मिळवूया! ⭐',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFFFFE082),
              child: ListTile(
                leading: const Text('⭐', style: TextStyle(fontSize: 34)),
                title: const Text('माझे स्टार्स',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('$stars स्टार्स मिळाले!'),
              ),
            ),
            const SizedBox(height: 8),
            for (final item in cards)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Text(item.$1, style: const TextStyle(fontSize: 32)),
                  title: Text(item.$2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      )),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => openPage(item.$3),
                ),
              ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'काही शिकण्याचे भाग इंटरनेटशिवाय चालतात. आवाजासाठी फोनमध्ये Text-to-Speech आवाज उपलब्ध असणे आवश्यक आहे.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final FlutterTts tts = FlutterTts();

  final List<String> lessons = [
    'स्वर: अ आ इ ई उ ऊ ए ऐ ओ औ अं अः',
    'क: क का कि की कु कू के कै को कौ',
    'ख: ख खा खि खी खु खू खे खै खो खौ',
    'ग: ग गा गि गी गु गू गे गै गो गौ',
    'च: च चा चि ची चु चू चे चै चो चौ',
    'ज: ज जा जि जी जु जू जे जै जो जौ',
    'ट: ट टा टि टी टु टू टे टै टो टौ',
    'त: त ता ति ती तु तू ते तै तो तौ',
    'द: द दा दि दी दु दू दे दै दो दौ',
    'न: न ना नि नी नु नू ने नै नो नौ',
    'प: प पा पि पी पु पू पे पै पो पौ',
    'ब: ब बा बि बी बु बू बे बै बो बौ',
    'म: म मा मि मी मु मू मे मै मो मौ',
    'र: र रा रि री रु रू रे रै रो रौ',
    'ल: ल ला लि ली लु लू ले लै लो लौ',
    'स: स सा सि सी सु सू से सै सो सौ',
    'ह: ह हा हि ही हु हू हे है हो हौ',
  ];

  Future<void> speak(String text) async {
    try {
      await tts.setLanguage('mr-IN');
      await tts.setSpeechRate(0.38);
      await tts.stop();
      await tts.speak(text);
    } catch (_) {}
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('अक्षरे आणि बाराखडी')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: lessons.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(lessons[index],
                style: const TextStyle(fontSize: 18)),
            trailing: const Icon(Icons.volume_up),
            onTap: () => speak(lessons[index]),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final void Function(int score, int total) onFinish;

  const QuizPage({super.key, required this.onFinish});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, Object>> questions = [
    {'q': 'आंब्याचा रंग कोणता असू शकतो?', 'a': ['निळा', 'पिवळा', 'जांभळा'], 'correct': 1},
    {'q': '१ नंतर कोणता अंक येतो?', 'a': ['२', '५', '९'], 'correct': 0},
    {'q': 'गाय काय देते?', 'a': ['दूध', 'पुस्तक', 'चेंडू'], 'correct': 0},
    {'q': 'आकाशाचा रंग कोणता दिसतो?', 'a': ['निळा', 'काळा', 'गुलाबी'], 'correct': 0},
    {'q': 'कुत्रा कोणता आवाज करतो?', 'a': ['म्याऊ', 'भू भू', 'कुकडू कू'], 'correct': 1},
  ];

  int index = 0;
  int score = 0;
  bool finished = false;
  bool answered = false;

  void answer(int selected) {
    if (answered || finished) return;
    setState(() {
      answered = true;
      if (selected == questions[index]['correct']) score++;
    });
  }

  void next() {
    if (!answered) return;
    if (index < questions.length - 1) {
      setState(() {
        index++;
        answered = false;
      });
    } else {
      setState(() => finished = true);
      widget.onFinish(score, questions.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Scaffold(
        appBar: AppBar(title: const Text('निकाल')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉 छान खेळलात!',
                  style: TextStyle(fontSize: 27)),
              Text('$score / ${questions.length} गुण',
                  style: const TextStyle(fontSize: 24)),
              const Text('तुम्हाला मिळाले ⭐ स्टार्स!',
                  style: TextStyle(fontSize: 19)),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('मुख्य पानावर जा'),
              ),
            ],
          ),
        ),
      );
    }

    final q = questions[index];
    final options = q['a'] as List<String>;

    return Scaffold(
      appBar: AppBar(title: const Text('प्रश्नमंजुषा')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('प्रश्न ${index + 1} / ${questions.length}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text(q['q'] as String,
                style: const TextStyle(
                    fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            for (int i = 0; i < options.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: answered ? null : () => answer(i),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(options[i],
                        style: const TextStyle(fontSize: 19)),
                  ),
                ),
              ),
            if (answered)
              Text(
                'योग्य उत्तर: ${options[q['correct'] as int]}',
                style: const TextStyle(
                    fontSize: 18, color: Colors.green),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: answered ? next : null,
              child: Text(index == questions.length - 1
                  ? 'निकाल पाहा'
                  : 'पुढचा प्रश्न'),
            ),
          ],
        ),
      ),
    );
  }
}

class GardenGame extends StatefulWidget {
  final VoidCallback onFinish;

  const GardenGame({super.key, required this.onFinish});

  @override
  State<GardenGame> createState() => _GardenGameState();
}

class _GardenGameState extends State<GardenGame> {
  int water = 0;
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('बाग फुलवूया')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🌱', style: TextStyle(fontSize: 75)),
              Text(
                finished ? '🌸 छान! फूल उमलले!' :
                water == 0 ? 'बियाण्याला पाणी द्या' :
                water == 1 ? '🌿 रोप वाढत आहे!' : '🌷 फूल उमलायला तयार!',
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text('पाण्याचे घोट: $water / 3',
                  style: const TextStyle(fontSize: 19)),
              const SizedBox(height: 20),
              if (!finished)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      water++;
                      if (water >= 3) {
                        finished = true;
                        widget.onFinish();
                      }
                    });
                  },
                  icon: const Icon(Icons.water_drop),
                  label: const Text('पाणी द्या 💧'),
                ),
              if (finished)
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('३ स्टार्स मिळाले! मुख्य पानावर जा'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoriesPage extends StatefulWidget {
  final VoidCallback onRead;

  const StoriesPage({super.key, required this.onRead});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  final FlutterTts tts = FlutterTts();
  final List<Map<String, String>> stories = [
    {
      'title': 'तहानलेला कावळा',
      'body': 'एका कावळ्याला खूप तहान लागली. त्याला एक मडके दिसले. मडक्यात थोडे पाणी होते. कावळ्याने मडक्यात खडे टाकले. पाणी वर आले आणि कावळ्याने पाणी प्यायले. तात्पर्य: युक्तीने काम केले तर यश मिळते.'
    },
    {
      'title': 'ससा आणि कासव',
      'body': 'ससा खूप वेगाने धावत असे. त्याने कासवाची थट्टा केली. दोघांनी शर्यत लावली. ससा झोपला आणि कासव हळूहळू पुढे गेले. कासवाने शर्यत जिंकली. तात्पर्य: सातत्याने प्रयत्न केल्यास यश मिळते.'
    },
    {
      'title': 'प्रामाणिक लाकूडतोड्या',
      'body': 'एक लाकूडतोड्या नदीकाठी काम करत होता. त्याची कुऱ्हाड नदीत पडली. त्याने खरे सांगितले. त्याच्या प्रामाणिकपणामुळे त्याला बक्षीस मिळाले. तात्पर्य: नेहमी प्रामाणिक राहावे.'
    },
  ];

  Future<void> readStory(String text) async {
    try {
      await tts.setLanguage('mr-IN');
      await tts.setSpeechRate(0.38);
      await tts.stop();
      await tts.speak(text);
      widget.onRead();
    } catch (_) {}
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('मराठी गोष्टी')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story['title']!,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(story['body']!,
                      style: const TextStyle(fontSize: 17)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => readStory(
                      '${story['title']}. ${story['body']}',
                    ),
                    icon: const Icon(Icons.volume_up),
                    label: const Text('गोष्ट ऐका'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProgressPage extends StatelessWidget {
  final int stars;
  final int bestScore;
  final int quizzes;
  final int stories;
  final int games;

  const ProgressPage({
    super.key,
    required this.stars,
    required this.bestScore,
    required this.quizzes,
    required this.stories,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    final progress = [
      ('⭐', 'एकूण स्टार्स', '$stars'),
      ('🧠', 'खेळलेल्या प्रश्नमंजुषा', '$quizzes'),
      ('🏅', 'सर्वोत्तम गुण', '$bestScore / 5'),
      ('📖', 'ऐकलेल्या गोष्टी', '$stories'),
      ('🌱', 'पूर्ण केलेले गेम्स', '$games'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('माझी प्रगती')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'शाब्बास! शिकत राहा! 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          for (final item in progress)
            Card(
              child: ListTile(
                leading: Text(item.$1, style: const TextStyle(fontSize: 30)),
                title: Text(item.$2),
                trailing: Text(
                  item.$3,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'प्रगती या फोनमध्ये जतन होते. अ‍ॅप हटवले किंवा फोनचा डेटा पुसला तर ही नोंद नष्ट होऊ शकते.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
