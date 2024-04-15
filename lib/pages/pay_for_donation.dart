import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PayForDonationPage extends StatefulWidget {
  final int id;
  const PayForDonationPage({super.key, required this.id});

  @override
  State<PayForDonationPage> createState() => _PayForDonationPageState();
}

class _PayForDonationPageState extends State<PayForDonationPage> {
  late TextEditingController _upiProofDocController;
  late TextEditingController _bankProofDocController;
  final _upiController = TextEditingController();
  File? upiProofDocument;
  File? bankProofDocument;
  File? _donationLetter;

  // Required variables for individual donation data
  Map<String, dynamic> donationData = {};
  bool isDataFetched = false;
  bool isDonationRequestFetched = false;
  late List<String> totalDonatedPerson = [];
  bool isScreenshotCorrect = false;
  String extractedTransactionID = "";

  int adminId = -1;

  // To get current login admin id
  Future<void> getAdminID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminId = prefs.getInt('adminId') ?? -1;
    });
  }

  // To fetch the data
  Future<void> fetchIndividualDonationData(String id) async {
    try {
      final String url = dotenv.env['TRACK_DONATION_ADMIN_API']!;

      final body = jsonEncode({'id': id});
      final request = http.Request('OPTIONS',
          Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;
      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("API Request successful");
        }

        final data = jsonDecode(await utf8.decodeStream(response.stream));
        donationData = data['donation'];
        String membersPaymented = donationData['members_paymented'];
        totalDonatedPerson = membersPaymented
            .split(",")
            .map((e) => e.replaceAll(RegExp(r'[\[\]]'), ''))
            .toList();

        setState(() {
          isDonationRequestFetched = true;
          if (kDebugMode) {
            print("Total donated persons");
          }
          for (int i = 0; i < totalDonatedPerson.length; i++) {
            if (kDebugMode) {
              print(totalDonatedPerson[i]);
            }
          }
        });
      } else {
        if (kDebugMode) {
          print('Failed to load data: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // To pay for donation via bank
  Future<void> payForDonationViaBank() async {
    try {
      final String url = dotenv.env['PAY_FOR_DONATION_API']!;

      final body = jsonEncode({
        'id': donationData['id'],
        'user_id': donationData['user_id'],
        "method": "bank",
        "amount": donationData['donated_amount'] ?? "00",
        "transition_id": extractedTransactionID
      });
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Donation approved successfully!');
        }

        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Donation Successfully",
          desc:
              "Your support of Rs. ${donationData['donated_amount'] ?? "00"} donated successfully",
          btnOkText: "OK",
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      } else {
        if (kDebugMode) {
          print('Failed to approval donation: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // To pay for donation via bank
  Future<void> payForDonationViaUPI() async {
    try {
      final String url = dotenv.env['PAY_FOR_DONATION_API']!;

      final body = jsonEncode({
        'id': donationData['id'],
        'user_id': donationData['user_id'],
        "method": "upi",
        "amount": donationData['donated_amount'] ?? "00",
        "transition_id": extractedTransactionID
      });
      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Donation approved successfully!');
        }

        AwesomeDialog(
          // ignore: use_build_context_synchronously
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title: "Donation Successfully",
          desc:
              "Your support of Rs. ${donationData['donated_amount'] ?? "00"} donated successfully",
          btnOkText: "OK",
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      } else {
        if (kDebugMode) {
          print('Failed to approval donation: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // to pick upi document proof
  Future<void> _pickDocument(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        if (type == 'proofDoc') {
          upiProofDocument = File(result.files.single.path!);
        } else {
          _donationLetter = File(result.files.single.path!);
        }
      });
    }
  }

  // to pick bank document proof
  Future<void> _pickBankDocument(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        if (type == 'proofDoc') {
          bankProofDocument = File(result.files.single.path!);
        } else {
          _donationLetter = File(result.files.single.path!);
        }
      });
    }
  }

  // Constructor
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdminID();
    _upiProofDocController = TextEditingController();
    _bankProofDocController = TextEditingController();
    fetchIndividualDonationData(widget.id.toString());
  }

  // Destructor
  @override
  void dispose() {
    _upiProofDocController.dispose();
    _bankProofDocController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.transparent,
            // Status bar brightness
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.dark, // For iOS (dark icons)
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Help",
            style: TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        body:

            // totalDonatedPerson.contains(adminId.toString())
            //     ? Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Lottie.asset("assets/animations/already_donated.json",
            //               animate: true, width: double.infinity),
            //           Text(
            //             "You have already donated!",
            //             style: TextStyle(
            //                 color: primaryColor.withOpacity(0.8),
            //                 fontSize: 24,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //           const SizedBox(height: 60),
            //         ],
            //       )
            //     :

            SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      donationData['title'] ?? "Not Available",
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),

                  // Total amount
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      donationData['donated_amount'] ?? "Amount Not Available",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  ExpansionTile(
                    title: const Text("Bank Details"),
                    children: [
                      Column(
                        children: [
                          ListTile(
                            leading:
                                const CircleAvatar(child: Icon(Icons.person)),
                            title: Text(
                                donationData['title'] ?? "Bank Holder Name"),
                          ),
                          ListTile(
                            leading: const CircleAvatar(
                                child: Icon(Icons.account_balance)),
                            title:
                                Text(donationData['bank_name'] ?? "Bank name"),
                          ),
                          ListTile(
                            leading: const CircleAvatar(
                                child: Icon(Icons.pin_rounded)),
                            title: Text(donationData['bank_account_number'] ??
                                "Bank Account Number"),
                          ),
                          ListTile(
                            leading:
                                const CircleAvatar(child: Icon(Icons.password)),
                            title:
                                Text(donationData['ifsc_code'] ?? "IFSC Code"),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _pickBankDocument('proofDoc');

                                if (bankProofDocument != null) {
                                  _extractText(bankProofDocument!);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                'Upload Screenshot',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (bankProofDocument != null)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Text(
                                    bankProofDocument!.path,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.black54),
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 20),
                              ],
                            )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              textStyle:
                                  TextStyle(color: primaryColor, fontSize: 18)),
                          onPressed: () {
                            if (bankProofDocument == null) {
                              AwesomeDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                showCloseIcon: true,
                                title: "Screenshot Not Attached",
                                desc:
                                    "Please attach the payment screenshot before continue",
                                btnOkText: "OK",
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              if (!isScreenshotCorrect || extractedTransactionID == "") {
                                AwesomeDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.topSlide,
                                  showCloseIcon: true,
                                  title: "Transaction ID not found",
                                  desc: "Unable to extract transaction ID!",
                                  btnOkText: "OK",
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                payForDonationViaBank();
                              }
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),

                  ExpansionTile(
                    title: const Text("Pay by UPI"),
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            "assets/images/qr-code.png",
                            width: 250,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const Card(
                            child: ListTile(
                              title: Text("UPI ID"),
                              trailing: Icon(Icons.copy),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await _pickDocument('proofDoc');

                                if (upiProofDocument != null) {
                                  _extractText(upiProofDocument!);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                'Upload Screenshot',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (upiProofDocument != null)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: Text(
                                    upiProofDocument!.path,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.black54),
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 20),
                              ],
                            ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              textStyle:
                                  TextStyle(color: primaryColor, fontSize: 18)),
                          onPressed: () {
                            if (upiProofDocument == null) {
                              AwesomeDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                showCloseIcon: true,
                                title: "Screenshot Not Attached",
                                desc:
                                    "Please attach the payment screenshot before continue",
                                btnOkText: "OK",
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              if (!isScreenshotCorrect || extractedTransactionID == "") {
                                AwesomeDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.topSlide,
                                  showCloseIcon: true,
                                  title: "Transaction ID not found",
                                  desc:
                                      "Unable to extract transaction ID. Please attach correct payment screenshot!",
                                  btnOkText: "OK",
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                payForDonationViaUPI();
                              }
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // To show extracted text and it is current unused
  Widget _extractTextView() {
    if (bankProofDocument == null) {
      return const Center(
        child: Text("No Result!"),
      );
    }

    return FutureBuilder(
        future: _extractText(bankProofDocument!),
        builder: (context, snapshot) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
            child: Container(
              color: secondaryColor,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Extracted text is:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    extractedTransactionID,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // To extract text from screenshot
  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    textRecognizer.close();

    if (text.toLowerCase().contains("upi ref") ||
        text.toLowerCase().contains("transaction id") ||
        text.toLowerCase().contains("utr") ||
        text.toLowerCase().contains("transaction successful") ||
        text.toLowerCase().contains("payment successful") ||
        text.toLowerCase().contains("payment to")) {
      isScreenshotCorrect = true;
      print("Screenshot verification status: $isScreenshotCorrect");
    } else {
      isScreenshotCorrect = false;
      print("Screenshot verification status: $isScreenshotCorrect");
      AwesomeDialog(
        // ignore: use_build_context_synchronously
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: "Transaction ID not found",
        desc:
            "Unable to extract transaction ID. Please attach correct payment screenshot!",
        btnOkText: "OK",
        btnOkOnPress: () {},
      ).show();
    }
    extractedTransactionID = text;

    return text;
  }
}
