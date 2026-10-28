
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

  final List<Map<String, String>> animals = [
    {'emoji': '🐶', 'name': 'कुत्रा', 'sound': 'भु भु भु'},
    {'emoji': '🐱', 'name': 'मांजर', 'sound': 'म्याऊ म्याऊ'},
    {'emoji': '🐮', 'name': 'गाय', 'sound': 'हंबा हंबा'},
    {'emoji': '🐘', 'name': 'हत्ती', 'sound': 'हत्तीचा आवाज'},
    {'emoji': '🦁', 'name': 'सिंह', 'sound': 'सिंहाची डरकाळी'},
    {'emoji': '🐒', 'name': 'माकड', 'sound': 'माकडाचा आवाज'},
    {'emoji': '🐰', 'name': 'ससा', 'sound': 'सशाचा आवाज'},
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
    await tts.setLanguage('mr-IN');
    await tts.setSpeechRate(0.38);
    await tts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> items;

    switch (widget.type) {
      case 'letters':
        items = [
          'अ आ इ ई उ ऊ ए ऐ ओ औ अं अः',
          'क का कि की कु कू के कै को कौ कं कः',
          'ख खा खि खी खु खू खे खै खो खौ खं खः',
          'ग गा गि गी गु गू गे गै गो गौ गं गः',
          'घ घा घि घी घु घू घे घै घो घौ घं घः',
          'ङ ङा ङि ङी ङु ङू ङे ङै ङो ङौ',
          'च चा चि ची चु चू चे चै चो चौ चं चः',
          'छ छा छि छी छु छू छे छै छो छौ छं छः',
          'ज जा जि जी जु जू जे जै जो जौ जं जः',
          'झ झा झि झी झु झू झे झै झो झौ झं झः',
          'ञ ञा ञि ञी ञु ञू ञे ञै ञो ञौ',
          'ट टा टि टी टु टू टे टै टो टौ टं टः',
          'ठ ठा ठि ठी ठु ठू ठे ठै ठो ठौ ठं ठः',
          'ड डा डि डी डु डू डे डै डो डौ डं डः',
          'ढ ढा ढि ढी ढु ढू ढे ढै ढो ढौ ढं ढः',
          'ण णा णि णी णु णू णे णै णो णौ णं णः',
          'त ता ति ती तु तू ते तै तो तौ तं तः',
          'थ था थि थी थु थू थे थै थो थौ थं थः',
          'द दा दि दी दु दू दे दै दो दौ दं दः',
          'ध धा धि धी धु धू धे धै धो धौ धं धः',
          'न ना नि नी नु नू ने नै नो नौ नं नः',
          'प पा पि पी पु पू पे पै पो पौ पं पः',
          'फ फा फि फी फु फू फे फै फो फौ फं फः',
          'ब बा बि बी बु बू बे बै बो बौ बं बः',
          'भ भा भि भी भु भू भे भै भो भौ भं भः',
          'म मा मि मी मु मू मे मै मो मौ मं मः',
          'य या यि यी यु यू ये यै यो यौ यं यः',
          'र रा रि री रु रू रे रै रो रौ रं रः',
          'ल ला लि ली लु लू ले लै लो लौ लं लः',
          'व वा वि वी वु वू वे वै वो वौ वं वः',
          'श शा शि शी शु शू शे शै शो शौ शं शः',
          'ष षा षि षी षु षू षे षै षो षौ षं षः',
          'स सा सि सी सु सू से सै सो सौ सं सः',
          'ह हा हि ही हु हू हे है हो हौ हं हः',
          'ळ ळा ळि ळी ळु ळू ळे ळै ळो ळौ ळं ळः',
          'क्ष क्षा क्षि क्षी क्षु क्षू क्षे क्षै क्षो क्षौ',
          'त्र त्रा त्रि त्री त्रु त्रू त्रे त्रै त्रो त्रौ',
          'ज्ञ ज्ञा ज्ञि ज्ञी ज्ञु ज्ञू ज्ञे ज्ञै ज्ञो ज्ञौ',
        ];
        break;

      case 'numbers':
        items = ['१','२','३','४','५','६','७','८','९','१०'];
        break;

      case 'colors':
        items = [
          '🔴 लाल', '🔵 निळा', '🟡 पिवळा',
          '🟢 हिरवा', '🟣 जांभळा', '🟠 नारिंगी',
        ];
        break;

      case 'animals':
        items = animals.map(
          (a) => '${a['emoji']} ${a['name']}',
        ).toList();
        break;

      default:
        items = [
          '⚪ वर्तुळ', '🟥 चौकोन',
          '🔺 त्रिकोण', '⭐ तारा', '❤️ हृदय',
        ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFFFD66B),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.15,
        ),
        itemBuilder: (context, index) {
          final text = items[index];

          return Card(
            color: Colors.white,
            elevation: 3,
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
                            fontSize: widget.type == 'letters'
                                ? 18
                                : 27,
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
    );
  }
}
