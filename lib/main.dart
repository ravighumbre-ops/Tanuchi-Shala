import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const TanuchiShalaApp());
}

class TanuchiShalaApp extends StatelessWidget {
  const TanuchiShalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'तानूची शाळा',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
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
      {'title': 'मराठी बाराखडी', 'type': 'letters', 'emoji': '🔤'},
      {'title': 'अंक शिकूया', 'type': 'numbers', 'emoji': '🔢'},
      {'title': 'रंग ओळखूया', 'type': 'colors', 'emoji': '🎨'},
      {'title': 'प्राणी ओळखूया', 'type': 'animals', 'emoji': '🐘'},
      {'title': 'आकार शिकूया', 'type': 'shapes', 'emoji': '⭐'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎒 तानूची शाळा',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFFD66B),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3D6), Color(0xFFEDE7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'चला मुलांनो, शिकूया आणि खेळूया! 😊',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            for (final lesson in lessons)
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Text(
                    lesson['emoji']!,
                    style: const TextStyle(fontSize: 34),
                  ),
                  title: Text(
                    lesson['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonPage(
                          title: lesson['title']!,
                          type: lesson['type']!,
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

class LessonPage extends StatefulWidget {
  final String title;
  final String type;

  const LessonPage({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final FlutterTts tts = FlutterTts();
  bool voiceReady = false;

  final List<Map<String, String>> animals = [
    {'emoji': '🐶', 'name': 'कुत्रा', 'sound': 'भू भू'},
    {'emoji': '🐱', 'name': 'मांजर', 'sound': 'म्याऊ म्याऊ'},
    {'emoji': '🐮', 'name': 'गाय', 'sound': 'हंबा हंबा'},
    {'emoji': '🐘', 'name': 'हत्ती', 'sound': 'हत्ती'},
    {'emoji': '🦁', 'name': 'सिंह', 'sound': 'सिंहाची डरकाळी'},
    {'emoji': '🐒', 'name': 'माकड', 'sound': 'माकड'},
    {'emoji': '🐰', 'name': 'ससा', 'sound': 'ससा'},
    {'emoji': '🐓', 'name': 'कोंबडा', 'sound': 'कुकडू कू'},
    {'emoji': '🐑', 'name': 'मेंढी', 'sound': 'में में'},
    {'emoji': '🦆', 'name': 'बदक', 'sound': 'क्वॅक क्वॅक'},
  ];

  @override
  void initState() {
    super.initState();
    setupVoice();
  }

  Future<void> setupVoice() async {
    try {
      await tts.setLanguage('mr-IN');
      await tts.setSpeechRate(0.38);
      await tts.setPitch(1.0);
      if (mounted) {
        setState(() => voiceReady = true);
      }
    } catch (_) {
      // फोनमध्ये मराठी आवाज उपलब्ध नसल्यास अ‍ॅप सुरू राहील.
    }
  }

  Future<void> speak(String text) async {
    try {
      await tts.stop();
      await tts.speak(text);
    } catch (_) {
      // आवाज उपलब्ध नसल्यास अ‍ॅप बंद होणार नाही.
    }
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  List<String> getItems() {
    switch (widget.type) {
      case 'letters':
        return [
          'स्वर: अ आ इ ई उ ऊ ऋ ए ऐ ओ औ अं अः',
          'क: क का कि की कु कू के कै को कौ कं कः',
          'ख: ख खा खि खी खु खू खे खै खो खौ खं खः',
          'ग: ग गा गि गी गु गू गे गै गो गौ गं गः',
          'घ: घ घा घि घी घु घू घे घै घो घौ घं घः',
          'च: च चा चि ची चु चू चे चै चो चौ चं चः',
          'छ: छ छा छि छी छु छू छे छै छो छौ छं छः',
          'ज: ज जा जि जी जु जू जे जै जो जौ जं जः',
          'झ: झ झा झि झी झु झू झे झै झो झौ',
          'ट: ट टा टि टी टु टू टे टै टो टौ',
          'ठ: ठ ठा ठि ठी ठु ठू ठे ठै ठो ठौ',
          'ड: ड डा डि डी डु डू डे डै डो डौ',
          'ढ: ढ ढा ढि ढी ढु ढू ढे ढै ढो ढौ',
          'ण: ण णा णि णी णु णू णे णै णो णौ',
          'त: त ता ति ती तु तू ते तै तो तौ',
          'थ: थ था थि थी थु थू थे थै थो थौ',
          'द: द दा दि दी दु दू दे दै दो दौ',
          'ध: ध धा धि धी धु धू धे धै धो धौ',
          'न: न ना नि नी नु नू ने नै नो नौ',
          'प: प पा पि पी पु पू पे पै पो पौ',
          'फ: फ फा फि फी फु फू फे फै फो फौ',
          'ब: ब बा बि बी बु बू बे बै बो बौ',
          'भ: भ भा भि भी भु भू भे भै भो भौ',
          'म: म मा मि मी मु मू मे मै मो मौ',
          'य: य या यि यी यु यू ये यै यो यौ',
          'र: र रा रि री रु रू रे रै रो रौ',
          'ल: ल ला लि ली लु लू ले लै लो लौ',
          'व: व वा वि वी वु वू वे वै वो वौ',
          'श: श शा शि शी शु शू शे शै शो शौ',
          'ष: ष षा षि षी षु षू षे षै षो षौ',
          'स: स सा सि सी सु सू से सै सो सौ',
          'ह: ह हा हि ही हु हू हे है हो हौ',
          'ळ: ळ ळा ळि ळी ळु ळू ळे ळै ळो ळौ',
          'क्ष: क्ष क्षा क्षि क्षी क्षु क्षू क्षे क्षै क्षो क्षौ',
          'त्र: त्र त्रा त्रि त्री त्रु त्रू त्रे त्रै त्रो त्रौ',
          'ज्ञ: ज्ञ ज्ञा ज्ञि ज्ञी ज्ञु ज्ञू ज्ञे ज्ञै ज्ञो ज्ञौ',
        ];

      case 'numbers':
        return [
          '१ - एक', '२ - दोन', '३ - तीन', '४ - चार',
          '५ - पाच', '६ - सहा', '७ - सात', '८ - आठ',
          '९ - नऊ', '१० - दहा',
        ];

      case 'colors':
        return [
          '🔴 लाल', '🔵 निळा', '🟡 पिवळा',
          '🟢 हिरवा', '🟣 जांभळा', '🟠 नारिंगी',
          '⚫ काळा', '⚪ पांढरा',
        ];

      case 'animals':
        return animals.map(
          (a) => '${a['emoji']} ${a['name']}',
        ).toList();

      default:
        return [
          '⚪ वर्तुळ', '🟥 चौकोन', '🔺 त्रिकोण',
          '⭐ तारा', '❤️ हृदय', '▭ आयत',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = getItems();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFFFD66B),
      ),
      body: Column(
        children: [
          if (!voiceReady)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'आवाज सुरू होत आहे...',
                style: TextStyle(fontSize: 13),
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final text = items[index];

                return Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      if (widget.type == 'animals') {
                        final animal = animals[index];
                        speak(
                          '${animal['name']}. ${animal['sound']}.',
                        );
                      } else {
                        speak(text);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      widget.type == 'letters' ? 16 : 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.volume_up,
                            color: Colors.deepPurple,
                            size: 26,
                          ),
                          const Text(
                            'आवाज ऐका',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

