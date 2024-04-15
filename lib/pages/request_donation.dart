import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mp_police/widget/widget.dart';

class RequestDonation extends StatelessWidget {
  const RequestDonation({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Lottie.asset("assets/animations/donation.json",
                            animate: true, width: 200),
                      ),
                    ),
                    Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: "Title",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: "Write Your Description Here",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecondScreen(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final String title;
  final String description;

  const SecondScreen({
    required this.title,
    required this.description,
  });

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  File? _proofDocument;
  File? _donationLetter;

  Future<void> _pickDocument(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        if (type == 'proofDoc') {
          _proofDocument = File(result.files.single.path!);
        } else {
          _donationLetter = File(result.files.single.path!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Documents Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Lottie.asset("assets/animations/document_proof.json",
                    animate: true, width: 200),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    height: 50,
                    width: 280,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _pickDocument('proofDoc');
                      },
                      child: const Text(
                        'Upload Document Proof',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_proofDocument != null)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          _proofDocument!.path,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    height: 50,
                    width: 280,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _pickDocument('donationLetter');
                      },
                      child: const Text(
                        'Upload Donation Letter (Optional)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_donationLetter != null)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          _donationLetter!.path,
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
                onPressed: () {
                  if (_proofDocument != null || _donationLetter != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThirdScreen(
                          title: widget.title,
                          description: widget.description,
                          proofDocument: _proofDocument,
                          donationLetter: _donationLetter,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please upload at least one document.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdScreen extends StatefulWidget {
  final String title;
  final String description;
  final File? proofDocument;
  final File? donationLetter;

  const ThirdScreen({
    required this.title,
    required this.description,
    required this.proofDocument,
    required this.donationLetter,
  });

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _accountNumberController;
  late TextEditingController _ifscCodeController;
  late TextEditingController _bankHolderNameController;
  late TextEditingController _upiIdController;

  @override
  void initState() {
    super.initState();
    _accountNumberController = TextEditingController();
    _ifscCodeController = TextEditingController();
    _bankHolderNameController = TextEditingController();
    _upiIdController = TextEditingController();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _bankHolderNameController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Input Fields
                Column(
                  children: [
                    _buildBankDetails(),
                    const SizedBox(height: 20),
                    _buildUpiDetails(),
                    const SizedBox(height: 20),
                  ],
                ),

                // Payment Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    height: 50,
                    width: 280,
                    child: ElevatedButton(
                      onPressed: _confirmDonationRequest,
                      child: const Text(
                        'Request Donation',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Bank Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _accountNumberController,
          decoration: InputDecoration(
            labelText: "Account Number",
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your account number.';
            }
            // Check if account number is valid (e.g., 10 digits)
            if (value.length != 10) {
              return 'Account number should be 10 digits.';
            }
            // Add more specific validation logic here
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _ifscCodeController,
          decoration: InputDecoration(
            labelText: "IFSC Code",
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your IFSC code.';
            }
            // Check if IFSC code is valid (e.g., 11 characters)
            if (value.length != 11) {
              return 'IFSC code should be 11 characters long.';
            }
            // Add more specific validation logic here
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _bankHolderNameController,
          decoration: InputDecoration(
            labelText: "Bank Holder Name",
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter the name of the bank holder.';
            }
            // Add more specific validation logic here
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUpiDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'UPI Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _upiIdController,
          decoration: InputDecoration(
            labelText: "UPI Id",
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'UPI ID is required';
            }
            // Add specific validation logic for UPI ID here
            // For example, you might want to check if it contains '@'
            if (!value.contains('@')) {
              return 'Invalid UPI ID format. It should contain "@" symbol.';
            }
            // Add more specific validation logic here
            return null;
          },
        ),
      ],
    );
  }

  void _confirmDonationRequest() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with donation request

      await _sendDonationRequest();
    }
  }

  Future<void> _sendDonationRequest() async {
    String accountNumber = _accountNumberController.text;
    String ifscCode = _ifscCodeController.text;
    String bankHolderName = _bankHolderNameController.text;
    String upiId = _upiIdController.text;

    try {
      // Convert files to base64
      String proofDocumentBase64 = '';
      String donationLetterBase64 = '';

      if (widget.proofDocument != null) {
        List<int> proofDocumentBytes =
            await widget.proofDocument!.readAsBytes();
        proofDocumentBase64 = base64Encode(proofDocumentBytes);
      }

      if (widget.donationLetter != null) {
        List<int> donationLetterBytes =
            await widget.donationLetter!.readAsBytes();
        donationLetterBase64 = base64Encode(donationLetterBytes);
      }

      await checkOptions(
        widget.title,
        widget.description,
        accountNumber,
        ifscCode,
        bankHolderName,
        upiId,
        proofDocumentBase64,
        donationLetterBase64,
      );

      _showSuccessDialog();
    } catch (error) {
      print('Error: $error');

      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Donation Requested Successfully",
      desc: "Your donation request has been successfully submitted",
      btnOkText: "OK",
      btnOkOnPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => DonationPendingScreen(
                    userId: UserSingleton().getUserId(),
                  )),
        );
      },
    ).show();
  }

  void _showErrorDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "Error",
      desc: "Failed to submit donation request. Please try again later.",
      btnOkText: "OK",
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }
}

Future<void> checkOptions(
  String title,
  String description,
  String accountNumber,
  String ifscCode,
  String bankHolderName,
  String upiId,
  String proofDocumentBase64,
  String donationLetterBase64,
) async {
  final String url = dotenv.env['CREATE_DONATION_API']!;

  try {
    final request = http.Request('OPTIONS', Uri.parse(url))
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode({
        'title': title,
        'reason': description,
        'bank_account_number': accountNumber,
        'ifsc_code': ifscCode,
        'bank_name': bankHolderName,
        'upi_id': upiId,
        'proof_link': proofDocumentBase64,
        'doc_link': donationLetterBase64,
      });

    final streamedResponse = await http.Client().send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print('OPTIONS request successful');
      print('response: ${response.body}');
    } else {
      print('Failed OPTIONS request: ${response.reasonPhrase}');
      throw Exception('Failed OPTIONS request: ${response.reasonPhrase}');
    }
  } catch (error) {
    print('Error making OPTIONS request: $error');
    throw error;
  }
}

class DonationPendingScreen extends StatelessWidget {
  final String userId;

  const DonationPendingScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _checkDonationStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final String? donationStatus = snapshot.data;
              return _buildContent(donationStatus!);
            }
          }
        },
      ),
    );
  }

  Future<String> _checkDonationStatus() async {
    final String apiUrl =
        'https://pscta.tdpvista.co.in/api/v1/donation/byuserid';
    try {
      final Uri url = Uri.parse(apiUrl + '?userId=$userId');
      final request = http.Request('OPTIONS', url);
      final streamedResponse = await http.Client().send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> donations = jsonData['donations'];
        if (donations.isNotEmpty) {
          final Map<String, dynamic> donation = donations.first;
          final String status = donation['status'];
          return status;
        } else {
          throw Exception('No donation data found');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw error;
    }
  }

  Widget _buildContent(String donationStatus) {
    if (donationStatus == 'active') {
      // Navigate to refill form
      // Example:
      // Navigator.push(context, MaterialPageRoute(builder: (context) => RefillFormScreen()));
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/login.png', // Add your completed image asset path here
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Your donation request is completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Thank you for your contribution. Your donation request has been completed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/login.png', // Add your pending image asset path here
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Your donation request is pending',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Your donation request is still being processed. Please wait for it to be completed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }
  }
}
