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
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFFFF8E8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7357E8),
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
    final lessons = [
      ('अ आ इ ई', 'मराठी अक्षरे', '🔤',
        const Color(0xFFFF8A65)),
      ('१ २ ३ ४', 'अंक शिकूया', '🔢',
        const Color(0xFF42A5F5)),
      ('🌈', 'रंग ओळखूया', '🎨',
        const Color(0xFFAB68E8)),
      ('🐘', 'प्राणी शिकूया', '🦁',
        const Color(0xFF43B982)),
      ('📖', 'गोष्टी ऐकूया', '🧸',
        const Color(0xFFFFB74D)),
      ('🌱', 'बागेचा गेम', '🌻',
        const Color(0xFF26A69A)),
      ('🧠', 'प्रश्नमंजुषा', '⭐',
        const Color(0xFFEC6090)),
      ('🏆', 'माझी प्रगती', '🌟',
        const Color(0xFF7986CB)),
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7857E8),
                      Color(0xFFB36CE8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.20),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 27,
                          backgroundColor: Colors.white,
                          child: Text(
                            '🎒',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'तानूची शाळा',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text('⭐',
                            style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'नमस्कार छोट्या मित्रा! 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'चला, खेळूया आणि नवीन गोष्टी शिकूया!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🚀',
                              style: TextStyle(fontSize: 22)),
                          SizedBox(width: 8),
                          Text(
                            'आज काहीतरी नवीन शिकूया!',
                            style: TextStyle(
                              color: Color(0xFF6542C5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: Text(
                  '🎈 चला शिकायला सुरुवात करूया!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF40345C),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = lessons[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LessonPage(
                              title: item.$2,
                              emoji: item.$3,
                              color: item.$4,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: item.$4.withOpacity(0.30),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: item.$4.withOpacity(0.12),
                              blurRadius: 9,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: item.$4.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                item.$3,
                                style: const TextStyle(
                                  fontSize: 39,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.$2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF35294B),
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.$1,
                              style: TextStyle(
                                color: item.$4,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: lessons.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.92,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  '💖 शिकूया, खेळूया, आनंदी राहूया!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7357E8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonPage extends StatelessWidget {
  final String title;
  final String emoji;
  final Color color;

  const LessonPage({
    super.key,
    required this.title,
    required this.emoji,
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 90)),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'छान! चला, मजेत शिकूया!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home),
                label: const Text('मुख्य स्क्रीनवर जा'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

