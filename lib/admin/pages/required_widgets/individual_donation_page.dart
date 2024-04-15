import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:mp_police/components/primary_button.dart';
import 'package:mp_police/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class IndividualDonationPage extends StatefulWidget {
  final int id;
  const IndividualDonationPage({super.key, required this.id});

  @override
  State<IndividualDonationPage> createState() => _IndividualDonationPageState();
}

class _IndividualDonationPageState extends State<IndividualDonationPage> {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        downloadAndOpenPDF(
                                            "https://drive.google.com/uc?export=download&id=$proofLink",
                                            "Police-Self-Care-Proof-${donationData['id'].toString()}.pdf");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      child: const Text(
                                        "View Proof",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
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
                                title: "Show Members",
                                onPressed: () {
                                  goTo(context,
                                      ShowAllMembers(id: widget.id.toString()));
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
  final String id;
  const ShowAllMembers({super.key, required this.id});

  @override
  State<ShowAllMembers> createState() => _ShowAllMembersState();
}

class _ShowAllMembersState extends State<ShowAllMembers> {
  String filteredValue = 'Paid';
  List<Map<String, dynamic>> allMembers = [];
  bool isDataFetched = false;

  // To Generate PDF
  final pdf = pw.Document();
  File? file;
  DateTime time = DateTime.now();

  String currentDate = DateFormat.d().format(DateTime.now());
  String currentMonth = DateFormat.M().format(DateTime.now());
  String currentYear = DateFormat.y().format(DateTime.now());

  String dropdownValue = 'Paid';

  // To fetch all members
  Future<void> fetchData() async {
    try {
      final String url = dotenv.env['TRACK_DONATION_ADMIN_API']!;
      final body = jsonEncode({'id': widget.id});

      final request = http.Request('OPTIONS', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = body;

      final http.StreamedResponse response = await http.Client().send(request);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Request successful");
        }

        final data = jsonDecode(await utf8.decodeStream(response.stream));
        final List<dynamic> members = dropdownValue == "Paid"
            ? data['paid_members']
            : data['non_paid_members'];

        // Filter users based on approved_status
        allMembers =
            members.map((member) => member as Map<String, dynamic>).toList();

        setState(() {
          isDataFetched = true;
        }); // Update the UI with the filtered users
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

  Future<void> writeOnPDF() async {
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Table(
          border: pw.TableBorder.all(color: PdfColor.fromHex("687074")),
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColor.fromHex("718639")),
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.all(8.0),
                  child: pw.Text("S. No.",
                      style: pw.TextStyle(
                          color: PdfColor.fromHex("ffffff"),
                          fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8.0),
                  child: pw.Text("Name",
                      style: pw.TextStyle(
                          color: PdfColor.fromHex("ffffff"),
                          fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.all(8.0),
                  child: pw.Text("Mobile",
                      style: pw.TextStyle(
                          color: PdfColor.fromHex("ffffff"),
                          fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center),
                ),
              ],
            ),
            ...List.generate(
              allMembers.length,
              (index) => pw.TableRow(
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Text("${index + 1}.",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Text(allMembers[index]["name"] ?? "Unavailable",
                        textAlign: pw.TextAlign.center),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Text(allMembers[index]["mobile"] ?? "Unavailable",
                        textAlign: pw.TextAlign.center),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ));
  }

  Future savePDF() async {
    await fetchData().then((_) async {
      final directory = await getExternalStorageDirectory();
      if (kDebugMode) {
        print(directory?.path);
      }

      file = File(
          "${directory?.path}/PSC AllDonations - $dropdownValue $currentYear-$currentMonth-$currentDate.pdf");

      final pdfBytes = await pdf.save();
      await file?.writeAsBytes(pdfBytes);
      // ignore: use_build_context_synchronously
      showSnackbar(context,
      "PDF Saved Successfully to File/Android/data/com.management.railway/files/PSC All Donations - $dropdownValue $currentYear-$currentMonth-$currentDate.pdf",
      bgColor: Colors.green);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchData();
    });
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Export to pdf button
                  SizedBox(
                    width: 100,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          writeOnPDF();
                          savePDF();
                        });
                      },
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
                        value: dropdownValue,
                        borderRadius: BorderRadius.circular(8),
                        dropdownColor: Colors.grey[200],
                        underline: SizedBox(
                          width: 0,
                          height: 0,
                        ),

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: ['Paid', 'Unpaid'].map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue ?? '';
                            fetchData();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isDataFetched
                ? allMembers.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "No Member Found 😊",
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              border: TableBorder.all(color: Colors.white30),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(
                                  decoration:
                                      BoxDecoration(color: primaryColor),
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
                                          "Profile",
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
                                          "Mobile",
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
                                  allMembers.length,
                                  (index) => TableRow(
                                    children: [
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "${index + 1}.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: allMembers[index]['img_url'] ==
                                                    "" ||
                                                allMembers[index]['img_url'] ==
                                                    null
                                            ? Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                    child: Icon(
                                                        Icons.person_rounded)))
                                            : Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      allMembers[index]
                                                          ['img_url']),
                                                ),
                                              ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            allMembers[index]["name"] ??
                                                "Unavailable",
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
                                            allMembers[index]["mobile"] ??
                                                "Unavailable",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                : Center(
                    child: Lottie.asset("assets/animations/loading.json",
                        animate: true, width: 250),
                  ),
          ],
        ),
      ),
    );
  }
}
