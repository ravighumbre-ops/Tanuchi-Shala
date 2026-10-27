
onPressed: () async {
  if (option == item['answer']) {
    score++;
    await widget.onStar();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '🎉🥳 यय्य! एकदम बरोबर! 🌟🏆 तू खूप हुशार आहेस!',
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    if (index < questions.length - 1) {
      setState(() => index++);
    } else {
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
            '🌟 तू ${questions.length} पैकी $score प्रश्नांची उत्तरे बरोबर दिलीस!\n\n'
            '🥳 तू खूप छान खेळलास!\n'
            '🚀 असाच शिकत राहा आणि चमकत राहा!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, height: 1.5),
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
                });
              },
              child: const Text('🔄 पुन्हा खेळ'),
            ),
          ],
        ),
      );
    }
  } else {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '😊 काही हरकत नाही, बाळा! 💪 पुन्हा प्रयत्न कर. '
          'तू नक्की शिकशील! 🌈✨',
        ),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 3),
      ),
    );
  }
},
