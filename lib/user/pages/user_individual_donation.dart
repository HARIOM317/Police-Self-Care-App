import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/components/primary_button.dart';
import 'package:mp_police/pages/pay_for_donation.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class UserIndividualDonationPage extends StatefulWidget {
  final int id;
  const UserIndividualDonationPage({super.key, required this.id});

  @override
  State<UserIndividualDonationPage> createState() =>
      _UserIndividualDonationPageState();
}

class _UserIndividualDonationPageState
    extends State<UserIndividualDonationPage> {
  // Required variables for individual donation data
  Map<String, dynamic> donationData = {};
  bool isDataFetched = false;
  bool isDonationRequestFetched = false;
  late List<String> totalDonatedPerson = [];
  bool isDownloading = false;
  double downloadProgress = 0.0;

  String docLink = "";
  String proofLink = "";

  // To fetch the data
  Future<void> fetchIndividualDonationData(String id) async {
    try {
      final String api = dotenv.env['TRACK_DONATION_ADMIN_API']!;

      final body = jsonEncode({'id': id});
      final request = http.Request('OPTIONS', Uri.parse(api))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;
      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("API Request successful");
        }

        final data = jsonDecode(await utf8.decodeStream(response.stream));
        donationData = data['donation'];
        print("Ram ram : $donationData");
        totalDonatedPerson = donationData['members_paymented'].split(",");

        // Extracting download file id from document link
        String doc_link_url = donationData['doc_link'].toString();
        RegExp doc_link_regExp = RegExp(r"/d/([^/]+)/");
        Match? doc_link_match = doc_link_regExp.firstMatch(doc_link_url);
        String doc_link_fileId = doc_link_match?.group(1) ?? '';
        docLink = doc_link_fileId;
        print("Document ID = $doc_link_fileId");

        // Extracting download file id from proof link
        String proof_link_url = donationData['proof_link'].toString();
        RegExp proof_link_regExp = RegExp(r"/d/([^/]+)/");
        Match? proof_link_match = proof_link_regExp.firstMatch(proof_link_url);
        String proof_link_fileId = proof_link_match?.group(1) ?? '';
        proofLink = proof_link_fileId;
        print("Document ID = $proof_link_fileId");

        setState(() {
          isDonationRequestFetched = true;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchIndividualDonationData(widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          // Status bar brightness
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: isDownloading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Lottie.asset(
                              "assets/animations/downloading.json",
                              animate: true,
                              width: 200),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16.0),
                              child: CircularProgressIndicator(
                                backgroundColor: secondaryColor,
                                color: primaryColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              child: Text(
                                "${downloadProgress.toStringAsFixed(2)}%",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              child: Text(
                                "Downloaded",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            // Title
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                donationData['title'] ?? "Title",
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),

                            // Description
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                donationData['reason'] ?? "Reason",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54),
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Button 1
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        downloadAndOpenPDF(
                                            "https://drive.google.com/uc?export=download&id=$docLink",
                                            "Police-Self-Care-Doc-${donationData['id'].toString()}.pdf");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      child: const Text(
                                        "View Doc",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),

                                // Button 1
                              ],
                            ),

                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Total Amount Collected",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      donationData['donated_amount'] ??
                                          "Data not available",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "No. of person paid",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      totalDonatedPerson.length.toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            PrimaryButton(
                                title: "PAY",
                                onPressed: () {
                                  goTo(
                                      context,
                                      PayForDonationPage(
                                          id: donationData['id']));
                                }),
                          ],
                        ),
                        Column(
                          children: [
                            const Divider(),
                            ExpansionTile(
                              title: const Text("Bank Details"),
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                      child: Icon(Icons.person)),
                                  title: Text(donationData['title'] ??
                                      "Bank Holder Name"),
                                ),
                                ListTile(
                                  leading: const CircleAvatar(
                                      child: Icon(Icons.account_balance)),
                                  title: Text(
                                      donationData['bank_name'] ?? "Bank name"),
                                ),
                                ListTile(
                                  leading: const CircleAvatar(
                                      child: Icon(Icons.pin_rounded)),
                                  title: Text(
                                      donationData['bank_account_number'] ??
                                          "Bank Account Number"),
                                ),
                                ListTile(
                                  leading: const CircleAvatar(
                                      child: Icon(Icons.password)),
                                  title: Text(
                                      donationData['ifsc_code'] ?? "IFSC Code"),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: const Text("UPI Details"),
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                      child: Icon(Icons.person)),
                                  title: Text(
                                      donationData['upi_id_holder_name'] ??
                                          "UPI Holder name"),
                                ),
                                ListTile(
                                  leading: const CircleAvatar(
                                      child: Icon(Icons.account_balance)),
                                  title:
                                      Text(donationData['upi_id'] ?? "UPI ID"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/qr-code.png",
                                    width: 200,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadAndOpenPDF(String url, String fileName) async {
    try {
      setState(() {
        isDownloading = true;
      });

      final request = http.Request('GET', Uri.parse(url));
      final http.StreamedResponse response = await request.send();

      final totalBytes = response.contentLength;
      final appDir = await getExternalStorageDirectory();
      final file = File('${appDir!.path}/$fileName');
      // final file = File('/path/to/$fileName');
      IOSink fileSink = file.openWrite();

      int byteCount = 0;
      final List<int> buffer = <int>[];

      response.stream.listen(
        (List<int> chunk) {
          byteCount += chunk.length;
          buffer.addAll(chunk);

          if (totalBytes != null) {
            // Calculate download progress if totalBytes is known
            final progress = (byteCount / totalBytes) * 100;
            print('Download progress: $progress%');

            setState(() {
              downloadProgress = progress;
            });
          }

          fileSink.add(chunk);
        },
        onDone: () async {
          await fileSink.close();
          OpenFile.open(file.path);
          setState(() {
            downloadProgress = 0.0;
            isDownloading = false;
          });
        },
        onError: (error) {
          print('Download error: $error');
          fileSink.close();
          setState(() {
            downloadProgress = 0.0;
            isDownloading = false;
          });
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Error downloading or opening PDF: $e');
    }
  }
}

class ShowAllMembers extends StatefulWidget {
  const ShowAllMembers({super.key});

  @override
  State<ShowAllMembers> createState() => _ShowAllMembersState();
}

class _ShowAllMembersState extends State<ShowAllMembers> {
  String filteredValue = 'All';

  var filteredOptions = [
    'All',
    'Paid',
    'Unpaid',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          // Status bar brightness
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
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
          "All Members",
          style: TextStyle(
              color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Button 1
                  SizedBox(
                    width: 100,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Export to PDF",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Button 2
                  SizedBox(
                    width: 100,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Export to CSV",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Filter dropdown
                  Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200], // Background color
                      border: Border.all(color: Colors.grey), // Border color
                    ),
                    child: Center(
                      child: DropdownButton(
                        // Initial Value
                        value: 'All',
                        borderRadius: BorderRadius.circular(8),
                        dropdownColor: Colors.grey[200],
                        underline: SizedBox(
                          width: 0,
                          height: 0,
                        ),

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: ['All', 'Paid', 'Unpaid'].map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.white30),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: primaryColor),
                        children: const [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "S. No.",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Name",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Payment Date",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Transaction ID",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(
                        20,
                        (index) => TableRow(
                          children: [
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "${index + 1}.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Data 2"),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Data 3"),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Data 4"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
