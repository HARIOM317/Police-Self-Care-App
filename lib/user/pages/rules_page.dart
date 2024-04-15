import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mp_police/widget/widget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RulesAndRegulationsScreen extends StatelessWidget {
  const RulesAndRegulationsScreen({Key? key}) : super(key: key);

  // Function to open PDF file
  Future<void> _launchPDF(BuildContext context) async {
    final pdfData = await rootBundle.load('assets/rules_and_regulations.pdf');
    final tempDir = await getTemporaryDirectory();
    final tempPdfFile = File('${tempDir.path}/temp.pdf');
    await tempPdfFile.writeAsBytes(pdfData.buffer
        .asUint8List(pdfData.offsetInBytes, pdfData.lengthInBytes));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFScreen(tempPdfFile.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<bool>(
          valueListenable: UserSingleton().languageNotifier,
          builder: (context, isHindi, child) {
            return Text(
              isHindi ? 'नियम और विनियम' : 'Rules and Regulations',
            );
          },
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RuleCard(
              ruleNumber: '1',
              ruleText:
                  'पुलिस सेल्फ केयर टीम का निर्माण पुलिस कर्मचारियों के साथ होने वाली अकस्मात घटना से पीडित परिवार की मदद के लिये किया गया है। हमारा प्रयास है कि इस टीम से अधिक से अधिक सदस्य जुड़ें एवं हमारे पुलिस परिवार को अधिक से अधिक सहयोग दें।',
            ),
            SizedBox(height: 16.0),
            RuleCard(
              ruleNumber: '2',
              ruleText:
                  'पुलिस सेल्फ केयर टीम से जुड़ने हेतु आवश्यक सूचना संबंधी फ़ार्म भरकर रजिस्ट्रेशन किया जाना अनिवार्य है, साथ ही PSCT का टेलीग्राम पर आधिकारिक ग्रुप बनाया गया है, जिस पर समय-समय पर सहयोग या नियम या अन्य महत्वपूर्ण सूचनाएं प्रदान की जाती रहती हैं। इसके साथ ही आवश्यकता पड़ने पर महत्वपूर्ण',
            ),
            SizedBox(height: 16.0),
            RuleCard(
              ruleNumber: '3',
              ruleText:
                  'निर्णय लेने संबंधी पोल या विचार सुझाव आदि के दृष्टिगत ग्रुप के सदस्यों को भी विचार रखने और पोल में भाग लेने का अवसर दिया जाता है। यही कारण है कि PSCT का सदस्य बनने के साथ ही महत्वपूर्ण सूचनाओं से अपडेट रहने हेतु टेलीग्राम ग्रुप को सप्ताह में कम से कम 2 बार देखने और अपडेट रहने की भी बाध्यता रखी गयी है।',
            ),
            SizedBox(height: 16.0),
            RuleCard(
              ruleNumber: '4',
              ruleText:
                  'PSCT द्वारा हेल्पलाइन नंबर सदस्यों की सुविधा हेतु आगामी समय में जारी किया जायेगा, जिस पर कॉल, व्हाट्सएप्प के माध्यम से जानकारी का आदान प्रदान किया जा सकता है। कोई भी सदस्य इस नम्बर पर कॉल या मैसेज करके सूचना दे/ले सकता है।',
            ),
            SizedBox(height: 16.0),
            RuleCard(
              ruleNumber: '5',
              ruleText:
                  'PSCT के निर्माण दिवस से ही यह नियम किया गया है कि सभी को हर सहयोग करना अनिवार्य होगा। जो सहयोग करेगा, उसी को सहयोग मिलेगा। नियमों के दुरुपयोग होने की संभावना के दृष्टिगत 15 दिन का लॉक इन पीरियड दिनांक निर्माण दिवस से घोषित किया गया। (यह नियम स्थापना दिवस से ही लागू रहेगा।)',
            ),
            ElevatedButton(
              onPressed: () => _launchPDF(context),
              child: Text(
                UserSingleton().languageNotifier.value
                    ? 'अधिक नियम पढ़ने के लिए पीडीएफ डाउनलोड करें'
                    : 'To read more rules download the PDF',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  final String path;

  PDFScreen(this.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<bool>(
          valueListenable: UserSingleton().languageNotifier,
          builder: (context, isHindi, child) {
            return Text(
              isHindi ? 'पीडीएफ दस्तावेज़' : 'PDF Document',
            );
          },
        ),
        backgroundColor: Colors.green,
      ),
      body: PDFView(
        filePath: path,
      ),
    );
  }
}

class RuleCard extends StatelessWidget {
  final String ruleNumber;
  final String ruleText;

  const RuleCard({
    Key? key,
    required this.ruleNumber,
    required this.ruleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.rule,
                  color: Colors.green,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Rule $ruleNumber:',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              ruleText,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
