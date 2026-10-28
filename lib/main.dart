import 'package:flutter/material.dart';

void main() {
  runApp(const TanuShalaApp());
}

class TanuShalaApp extends StatelessWidget {
  const TanuShalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'तानूची शाळा',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7657E8),
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
      ('🌱', 'बागेचा गेम', const Color(0xFF35A86B)),
      ('🔤', 'मराठी अक्षरे', const Color(0xFFEC8C43)),
      ('🔢', 'अंक शिकूया', const Color(0xFF4285E8)),
      ('🧠', 'प्रश्नमंजुषा', const Color(0xFFBA65D8)),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E8),
      appBar: AppBar(
        title: const Text(
          '🎒 तानूची शाळा',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF7657E8),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7657E8),
                  Color(0xFFB36CE8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('👧🏻 🧒🏻 🌈',
                    style: TextStyle(fontSize: 42)),
                SizedBox(height: 12),
                Text(
                  'नमस्कार छोट्या मित्रा!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'चला, खेळूया आणि शिकूया!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            '🎈 आपले खेळ आणि शिकवणी',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: games.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final item = games[index];

              return Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GardenGame(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LearningPage(
                            emoji: item.$1,
                            title: item.$2,
                            color: item.$3,
                          ),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.$1,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.$2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: item.$3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text('खेळण्यासाठी टॅप करा'),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
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
  int stage = 0;
  int water = 0;
  int stars = 0;

  void plantSeed() {
    setState(() {
      stage = 1;
    });
  }

  void waterPlant() {
    if (stage == 0 || stage >= 4) return;

    setState(() {
      water++;
      stage++;

      if (stage == 4) {
        stars++;
      }
    });
  }

  void restartGame() {
    setState(() {
      stage = 0;
      water = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final plant = switch (stage) {
      0 => '🟤',
      1 => '🌱',
      2 => '🌿',
      3 => '🪴',
      _ => '🌳',
    };

    final message = switch (stage) {
      0 => 'मातीमध्ये बियाणे लावा!',
      1 => 'छान! आता पाणी द्या.',
      2 => 'कोंब वाढत आहे! पाणी द्या.',
      3 => 'झाड मोठे होत आहे!',
      _ => 'शाब्बास! तुमचे झाड वाढले! 🎉',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFE9F9E9),
      appBar: AppBar(
        title: const Text('🌱 बागेचा गेम'),
        backgroundColor: const Color(0xFF238B50),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'आपली छोटी बाग',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '⭐ मिळवलेले तारे: $stars',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A6500),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 35),
                decoration: BoxDecoration(
                  color: const Color(0xFFBDECB6),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFF78C76E),
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    const Text('☀️ 🦋 ☁️',
                        style: TextStyle(fontSize: 30)),
                    const SizedBox(height: 18),
                    Text(
                      plant,
                      style: const TextStyle(fontSize: 100),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (stage == 0)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: plantSeed,
                    icon: const Text('🌰'),
                    label: const Text('बियाणे लावा'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF238B50),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                )
              else if (stage < 4)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: waterPlant,
                    icon: const Text('💧'),
                    label: const Text('झाडाला पाणी द्या'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF238B50),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                )
              else
                const Text(
                  '🏆 अभिनंदन! तुम्ही झाड वाढवले!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF238B50),
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: restartGame,
                icon: const Icon(Icons.refresh),
                label: const Text('पुन्हा खेळा'),
              ),
              const SizedBox(height: 8),
              Text('दिलेली पाण्याची मात्रा: $water'),
            ],
          ),
        ),
      ),
    );
  }
}

class LearningPage extends StatelessWidget {
  final String emoji;
  final String title;
  final Color color;

  const LearningPage({
    super.key,
    required this.emoji,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 90)),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'शाब्बास! शिकत राहा! 🌟',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('मागे जा'),
            ),
          ],
        ),
      ),
    );
  }
}

