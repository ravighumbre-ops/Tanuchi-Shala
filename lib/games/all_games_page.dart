
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

const List<Map<String, dynamic>> games = [
  {'title': 'प्राण्यांचे आवाज', 'emoji': '🐘', 'color': Color(0xFFFFE0B2)},
  {'title': 'फुगे फोडा', 'emoji': '🎈', 'color': Color(0xFFFFCDD2)},
  {'title': 'फळांची टोपली', 'emoji': '🍎', 'color': Color(0xFFC8E6C9)},
  {'title': 'सशाचा भूलभुलैया', 'emoji': '🐰', 'color': Color(0xFFE1BEE7)},
  {'title': 'आकार जुळवा', 'emoji': '🔷', 'color': Color(0xFFBBDEFB)},
  {'title': 'तारे मोजा', 'emoji': '⭐', 'color': Color(0xFFFFF9C4)},
  {'title': 'छोटा शेफ', 'emoji': '👩‍🍳', 'color': Color(0xFFFFE0B2)},
  {'title': 'जादूची जोडी', 'emoji': '🧠', 'color': Color(0xFFD1C4E9)},
];

class AllGamesPage extends StatelessWidget {
  const AllGamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E8),
      appBar: AppBar(
        title: const Text('🎒 तानूची शाळा'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFB74D),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: games.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, i) {
          final game = games[i];
          return InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GamePlayPage(gameIndex: i),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: game['color'] as Color,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(game['emoji'] as String,
                      style: const TextStyle(fontSize: 54)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      game['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('खेळूया! 🚀',
                      style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GamePlayPage extends StatefulWidget {
  final int gameIndex;
  const GamePlayPage({super.key, required this.gameIndex});

  @override
  State<GamePlayPage> createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  final FlutterTts tts = FlutterTts();
  final Random random = Random();

  int round = 0;
  int stars = 0;
  int rabbitStep = 0;
  int selectedCount = 0;
  bool finished = false;

  final Set<String> ingredients = {};
  late List<String> memoryCards;
  final Set<int> revealed = {};
  final Set<int> matched = {};
  int? firstCard;
  bool checkingPair = false;

  final List<Map<String, String>> animals = [
    {'emoji': '🐘', 'name': 'हत्ती'},
    {'emoji': '🦁', 'name': 'सिंह'},
    {'emoji': '🐒', 'name': 'माकड'},
    {'emoji': '🐄', 'name': 'गाय'},
    {'emoji': '🐶', 'name': 'कुत्रा'},
    {'emoji': '🐱', 'name': 'मांजर'},
  ];

  final List<Map<String, String>> fruits = [
    {'emoji': '🍎', 'name': 'सफरचंद'},
    {'emoji': '🥭', 'name': 'आंबा'},
    {'emoji': '🍌', 'name': 'केळे'},
    {'emoji': '🍇', 'name': 'द्राक्षे'},
    {'emoji': '🍊', 'name': 'संत्रे'},
    {'emoji': '🍓', 'name': 'स्ट्रॉबेरी'},
  ];

  final List<Map<String, String>> shapes = [
    {'emoji': '🔴', 'name': 'गोल'},
    {'emoji': '🟦', 'name': 'चौकोन'},
    {'emoji': '🔺', 'name': 'त्रिकोण'},
    {'emoji': '⭐', 'name': 'तारा'},
  ];

  final List<Map<String, String>> vegetables = [
    {'emoji': '🥕', 'name': 'गाजर'},
    {'emoji': '🥔', 'name': 'बटाटा'},
    {'emoji': '🍅', 'name': 'टोमॅटो'},
    {'emoji': '🥦', 'name': 'ब्रोकोली'},
  ];

  @override
  void initState() {
    super.initState();
    _prepareMemory();
    _say('चला मुलांनो, खेळायला सुरुवात करूया!');
  }

  Future<void> _say(String message) async {
    try {
      await tts.setLanguage('mr-IN');
      await tts.setSpeechRate(0.42);
      await tts.speak(message);
    } catch (_) {
      // फोनमध्ये मराठी आवाज नसल्यास गेम आवाजाशिवाय चालेल.
    }
  }

  void _prepareMemory() {
    memoryCards = ['🐱', '🐶', '🐸', '🦁', '🐱', '🐶', '🐸', '🦁'];
    memoryCards.shuffle(random);
  }

  void _correct(String message) {
    if (!mounted) return;
    SystemSound.play(SystemSoundType.click);
    setState(() {
      stars++;
      round++;
    });
    _say('शाब्बास! $message एक स्टार मिळाला!');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('शाब्बास! ⭐ $message'),
        duration: const Duration(milliseconds: 900),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _wrong() {
    SystemSound.play(SystemSoundType.alert);
    _say('पुन्हा प्रयत्न कर बाळा!');
  }

  void _answer(bool correct, String message) {
    if (correct) {
      _correct(message);
    } else {
      _wrong();
    }
  }

  Widget _option(String emoji, String label, VoidCallback onTap,
      {Color color = Colors.white}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        constraints: const BoxConstraints(minHeight: 100),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade200, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 38)),
            const SizedBox(height: 5),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _options(List<Map<String, String>> items,
      Map<String, String> correct, String question) {
    final choices = <Map<String, String>>[correct];
    final others = items.where((e) => e['name'] != correct['name']).toList()
      ..shuffle(random);
    choices.addAll(others.take(3));
    choices.shuffle(random);

    return Column(
      children: [
        Text(question,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: choices.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, i) {
            final item = choices[i];
            return _option(
              item['emoji']!,
              item['name']!,
              () => _answer(
                item['name'] == correct['name'],
                item['name']!,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _animalGame() {
    final animal = animals[round % animals.length];
    return _options(animals, animal, 'हा कोणता प्राणी आहे?');
  }

  Widget _balloonGame() {
    final letters = ['अ', 'आ', 'इ', 'ई', 'उ', 'ऊ'];
    final numbers = ['१', '२', '३', '४', '५', '६'];
    final useNumber = round.isOdd;
    final correct = useNumber ? numbers[round % 6] : letters[round % 6];
    final list = useNumber ? numbers : letters;
    final choices = <String>[correct];
    final other = list.where((e) => e != correct).toList()
      ..shuffle(random);
    choices.addAll(other.take(3));
    choices.shuffle(random);

    return Column(
      children: [
        Text(
          'योग्य फुगा फोडा: $correct',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: choices.map((item) {
            return InkWell(
              onTap: () => _answer(item == correct, item),
              child: Container(
                width: 125,
                height: 125,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: [
                    Colors.pink.shade200,
                    Colors.blue.shade200,
                    Colors.yellow.shade300,
                    Colors.purple.shade200,
                  ][choices.indexOf(item)],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Text(item,
                    style: const TextStyle(
                        fontSize: 38, fontWeight: FontWeight.bold)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _fruitGame() {
    final fruit = fruits[round % fruits.length];
    return _options(fruits, fruit, '${fruit['name']} निवडा!');
  }

  Widget _mazeGame() {
    return Column(
      children: [
        const Text('सशाला गाजरापर्यंत पोहोचवा!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Container(
          width: 270,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text('🥕 गाजर', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 12),
              Text(
                '${'🟩 ' * rabbitStep}🐰',
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(height: 10),
              Text('पावले: $rabbitStep / 5'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {
                if (rabbitStep < 5) {
                  setState(() => rabbitStep++);
                  if (rabbitStep == 5) {
                    _correct('ससा घरी पोहोचला!');
                  } else {
                    _say('छान! पुढे जा.');
                  }
                } else {
                  _say('ससा पोहोचला!');
                }
              },
              child: const Text('➡️ पुढे जा'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => rabbitStep = 0);
                _say('पुन्हा सुरू करूया!');
              },
              child: const Text('🔄 पुन्हा'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _shapeGame() {
    final shape = shapes[round % shapes.length];
    return _options(shapes, shape, '${shape['name']} शोधा!');
  }

  Widget _starGame() {
    final count = round % 10 + 1;
    final answers = <int>{count};
    while (answers.length < 4) {
      answers.add(random.nextInt(10) + 1);
    }
    final choices = answers.toList()..shuffle(random);

    return Column(
      children: [
        const Text('तारे मोजा!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Wrap(
          alignment: WrapAlignment.center,
          children: List.generate(
            count,
            (_) => const Text('⭐', style: TextStyle(fontSize: 30)),
          ),
        ),
        const SizedBox(height: 20),
        const Text('किती तारे आहेत?',
            style: TextStyle(fontSize: 20)),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          children: choices.map((n) {
            return ElevatedButton(
              onPressed: () => _answer(n == count, '$n तारे'),
              child: Text('$n',
                  style: const TextStyle(fontSize: 24)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _chefGame() {
    return Column(
      children: [
        const Text('चला, भाजी बनवूया! 👩‍🍳',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const Text('तीन भाज्या निवडा.'),
        const SizedBox(height: 15),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: vegetables.map((v) {
            final selected = ingredients.contains(v['name']);
            return SizedBox(
              width: 135,
              child: _option(
                v['emoji']!,
                v['name']!,
                () {
                  setState(() {
                    if (selected) {
                      ingredients.remove(v['name']);
                    } else if (ingredients.length < 3) {
                      ingredients.add(v['name']!);
                    }
                  });
                  _say(v['name']!);
                },
                color: selected ? Colors.lightGreen.shade200 : Colors.white,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
        Text('निवडलेल्या भाज्या: ${ingredients.length}/3'),
        ElevatedButton.icon(
          onPressed: () {
            if (ingredients.length == 3) {
              _correct('मस्त भाजी तयार झाली!');
              setState(() => ingredients.clear());
            } else {
              _say('आणखी भाज्या निवडा!');
            }
          },
          icon: const Icon(Icons.restaurant),
          label: const Text('भाजी तयार करा'),
        ),
      ],
    );
  }

  Widget _memoryGame() {
    return Column(
      children: [
        const Text('सारखी चित्रे शोधा!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
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
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text('जोड्या: ${matched.length ~/ 2} / 4'),
        TextButton(
          onPressed: () {
            setState(() {
              revealed.clear();
              matched.clear();
              firstCard = null;
              checkingPair = false;
              _prepareMemory();
            });
          },
          child: const Text('पुन्हा खेळा 🔄'),
        ),
      ],
    );
  }

  void _flipCard(int i) {
    if (checkingPair ||
        revealed.contains(i) ||
        matched.contains(i)) return;

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
        stars++;
      });
      _say('शाब्बास! जोडी मिळाली!');
      if (matched.length == memoryCards.length) {
        _say('अभिनंदन! सर्व जोड्या मिळाल्या!');
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
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = games[widget.gameIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E8),
      appBar: AppBar(
        title: Text(game['title'] as String),
        backgroundColor: game['color'] as Color,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Text('⭐ $stars',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(game['emoji'] as String,
                        style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 8),
                    _gameBody(),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: () => _say(
                        'नमस्कार बाळांनो! चला शिकूया आणि खेळूया!',
                      ),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('मराठीत ऐका 🔊'),
                    ),
                    const SizedBox(height: 6),
                    Text('तुझे स्टार्स: $stars ⭐',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: Fon
