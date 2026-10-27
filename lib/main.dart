onPressed: () async {
  if (answered) return;

  if (option == item['answer']) {
    setState(() {
      score++;
      answered = true;
    });

    await widget.onStar();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '🎉🥳 व्वा! अगदी बरोबर! 🌟\n'
          'तू खूप हुशार आहेस! 🏆👏',
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    if (index == questions.length - 1) {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: const Color(0xFFFFF3D6),
          title: const Text(
            '🏆🎉 शाब्बास चॅम्पियन! 🎉🏆',
            textAlign: TextAlign.center,
          ),
          content: Text(
            '🌟 ${questions.length} पैकी $score '
            'प्रश्नांची उत्तरे बरोबर!\n\n'
            '🥳 तू खूप छान खेळलास!\n'
            '💖 आम्हाला तुझा अभिमान आहे!\n'
            '🚀 असाच शिकत राहा! ✨',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('🏠 घरी जा'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  index = 0;
                  score = 0;
                  answered = false;
                });
              },
              child: const Text('🔄 पुन्हा खेळ'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('👇 आता पुढचा प्रश्न सोडव!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '😊 काही हरकत नाही, बाळा! 💪\n'
          'पुन्हा प्रयत्न कर! 🌈',
        ),
        backgroundColor: Colors.deepPurple,
        duration: Duration(seconds: 3),
      ),
    );
  }
},
